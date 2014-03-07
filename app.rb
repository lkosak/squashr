require 'sinatra'
require 'data_mapper'
require 'json'
require 'active_support/values/time_zone'
require 'active_support/core_ext/time/calculations'
require 'chronic'

APPROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(APPROOT) unless $LOAD_PATH.include?(APPROOT)

require 'models/instruction'
require 'models/reservation'
require 'models/user'
require 'services/valet'

# Set time zone
Time.zone = "UTC"
Chronic.time_class = Time.zone

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/dev.db")
DataMapper.finalize.auto_upgrade!

class Squashr < Sinatra::Base
  APP_URL = "http://squashr.com"

  post '/receiver' do
    user = User.first(phone_number: params[:phone_number])

    unless user.present?
      return "We don't know who you are! Register at #{APP_URL}"
    end

    instruction = Instruction.new(params[:instruction])

    begin
      Valet.new(user, instruction).run
    rescue Valet::Error => e
      return "Error booking: #{e} #{e.message}"
    end

    "OK"
  end
end
