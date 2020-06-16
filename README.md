# README

This is a RoR application. Pretty barebone. However, this repo shows you how to use different caching layers, and lets you mimic some of the behaviour that could be used in conjunction with Lambda@Edge.


# Installing app and Dependencies
Enable caching in development mode
```rails dev:cache```
```bundle install```

Install imagemagic
`brew install imagemagic`

## Running Prod / Dev locally

Local dev:
`rails s`

Local prod:
`rails assets:precompile`
`RAILS_SERVE_STATIC_FILES=true rails server -e production`

# Rake tasks
Adding a new rake task called `precompile_assets` that runs through image files and performs conversions when `rake assets:precompile` runs

.
