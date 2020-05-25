# https://devcenter.heroku.com/articles/http-caching-ruby-rails
class ViewCacheController < ApplicationController
    include BenchmarkHelper

    def index
        bm = Object.new
        bm.extend(BenchmarkHelper)
        render locals: { helper: bm, ttl: ttl }
    end
    
    private
    
end
