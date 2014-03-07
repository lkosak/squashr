require 'bundler/setup'
require 'sinatra'

Sinatra::Application.environment = :test
Bundler.require :default, Sinatra::Application.environment

require 'rspec'

require File.join(File.dirname(__FILE__), '..', 'app')

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
end
