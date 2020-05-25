# https://devcenter.heroku.com/articles/http-caching-ruby-rails
class BrowserCacheController < ApplicationController
    include BenchmarkHelper

    before_action :before_action_fresh_when, except: [:etag_based_on_content_short_ttl]

    def short_ttl
        expires_in 5.seconds
        work description: 'The content of this page refreshes every 5 seconds'
    end

    def indefinite
        work description: 'The content of this page does not refresh'
    end

    def etag_based_on_content_short_ttl
        ttl = 5.seconds
        etag = Rails.cache.fetch('etag_based_on_content_short_ttl', expires_in: ttl) { 
            SecureRandom.uuid 
        }

        if stale? etag: etag
            work description: "This page refreshes every #{ttl} seconds. #{etag}"
        end
    end

    private

    def before_action_fresh_when
        fresh_when etag: request.fullpath unless request.path.include? 'tracker'
    end

    def work(description: '', content: '')
        bms = benchmark do |x|
            x.report("Cached value first pass:") { cache }
            x.report("Cached value:") { cache }
            x.report("No cache:") { no_cache }
        end

        render template: 'render_content', locals: { description: description.html_safe, content: content.html_safe << bms.join('<br />').html_safe }
    end
end
