class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :phone_number, String
  property :created_at, DateTime
  property :updated_at, DateTime

  property :xpiron_username, String
  property :xpiron_password, String
end
