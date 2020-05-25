# README

Enable caching in development mode
`rails dev:cache`

# Dependencies

Install imagemagic
`brew install imagemagic`

## Run locally
`bundle install`
`rails s`

## Run production mode
`rails assets:precompile`
`RAILS_SERVE_STATIC_FILES=true rails server -e production`

# Rake tasks
Adding a new rake task called `precompile_assets` that runs through image files and performs conversions when `rake assets:precompile` runs