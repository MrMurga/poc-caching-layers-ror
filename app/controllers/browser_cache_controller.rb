# https://devcenter.heroku.com/articles/http-caching-ruby-rails
class BrowserCacheController < ApplicationController
    include BenchmarkHelper

    before_action :before_action_fresh_when, except: [:etag_based_on_content]

    def short_ttl
        expires_in ttl, public: true
        work description: "[#{SecureRandom.uuid}] The content of this page is set to expire every #{ttl} seconds, but may not refresh because the etag is the same. Important: know this behaviour"
    end

    def indefinite_with_tracker
        tracker = <<-JS
            <div id="tracked-view">
                <iframe src="#{pixel_tracker_path}" width="200" height="50"></iframe>
            </div>
        JS
        work description: "[#{SecureRandom.uuid}] The content of this page does not refresh, but homepage views are tracked. Current views: #{cookies[:views] || 'N/A'}<br /><br />#{tracker}"
    end

    def indefinite
        work description: "[#{SecureRandom.uuid}] The content of this page does not refresh"
    end

    def etag_based_on_content
        etag_based_on_content = 'etag_based_on_content'
        if (request.headers['If-None-Match'].nil?)
            Rails.cache.delete(etag_based_on_content)
        end

        etag = Rails.cache.fetch(etag_based_on_content, expires_in: ttl) { 
            SecureRandom.uuid 
        }

        if stale? etag: etag
            work description: "[#{etag}] This page is cached but will refresh every #{ttl} seconds because the ETag will change. Note that the etag is computed everytime, so there's server work"
        end
    end

    def pixel_tracker
        increase_views
        render plain: "[#{SecureRandom.uuid}] View tracked - OK - #{cookies[:views]}"
    end

    private

    def increase_views
        cookies[:views] = (cookies[:views].to_i || 0) + 1
    end

    def before_action_fresh_when
        fresh_when etag: request.fullpath unless request.path.include? 'pixel_tracker'
    end

    def work(description: '', content: '')
        reset_cache
        bms = benchmark do |x|
            x.report("Cached value first pass:") { cache }
            x.report("Cached value:") { cache }
            x.report("No cache:") { no_cache }
        end

        render template: 'render_content', locals: { description: description.html_safe, content: content.html_safe << bms.join('<br />').html_safe }
    end
end
