class InMemoryCacheController < ApplicationController
    include BenchmarkHelper
    
    def index
        reset_cache
        bms = benchmark do |x|
            x.report("Cached value first pass:") { cache }
            x.report("Cached value:") { cache }
            x.report("No cache:") { no_cache }
        end

        render template: 'render_content', locals: { description: "[#{SecureRandom.uuid}] In-Memory caching example", content: bms.join('<br />').html_safe }
    end

    private
end
