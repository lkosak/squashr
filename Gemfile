source "https://rubygems.org"

ruby "2.0.0"

gem 'sinatra', '~> 1.3'
gem "thin"
gem 'data_mapper'
gem 'chronic'

gem 'dm-core'
gem 'dm-validations'
gem 'dm-aggregates'
gem 'dm-pager'

group :development do
  gem 'shotgun'
  gem 'pry', require: true
  gem 'heroku'
  gem 'dm-sqlite-adapter'
end

group :production do
  gem 'dm-postgres-adapter'
end
