require 'sinatra'
require 'data_mapper'
require 'json'
require 'chronic'

require 'models/user'
require 'models/reservation'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/dev.db")
DataMapper.finalize.auto_upgrade!

class Squashr
  APP_URL = "http://squashr.com"

  get '/receiver' do
    user = User.find(phone_number: params[:phone_number])

    unless user.present?
      return response("We don't know who you are! Register at #{APP_URL}")
    end

    instruction = Instruction.new(params[:instruction])

    begin
      Valet.run(user, instruction)
    rescue Valet::Error => e
      return response("Error: #{e.message}")
    end

    return response("Success")
  end

  private

  def response(msg)
    msg
  end
end
