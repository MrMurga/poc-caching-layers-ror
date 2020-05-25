Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'application#index'

  get '/in-memory-cache', to: 'in_memory_cache#index'

  get '/browser-cache-indefinite', to: 'browser_cache#indefinite'
  get '/browser-cache-short-ttl', to: 'browser_cache#short_ttl'
  get '/browser-cache-etag-based-on-content-short-ttl', to: 'browser_cache#etag_based_on_content_short_ttl'

  get '/view-cache', to: 'view_cache#index'
end
