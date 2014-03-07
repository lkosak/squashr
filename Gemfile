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
gem 'active_support'

group :development do
  gem 'shotgun'
  gem 'heroku'
  gem 'dm-sqlite-adapter'
end

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'database_cleaner'
end

group :production do
  gem 'dm-postgres-adapter'
end
