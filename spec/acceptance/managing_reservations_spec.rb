require 'spec_helper'
require 'rack/test'

describe "Managing a reservation" do
  include Rack::Test::Methods

  let!(:user) do
    User.create(name: 'Lou Kosak', phone_number: '917 828 0128')
  end

  def app
    Squashr
  end

  let(:start_time) { DateTime.new(2014, 1, 1, 8, 15) }

  let(:booking_params) {{
    phone_number: user.phone_number,
    instruction: 'book 1/1/14 8:15am'
  }}

  let(:cancel_params) {{
    phone_number: user.phone_number,
    instruction: 'cancel 1/1/14 8:15am'
  }}

  it "creates a new reservation" do
    post '/receiver', booking_params
    last_response.should be_ok
    reservation = Reservation.last
    reservation.user_id.should == user.id
    reservation.start_time.should == start_time
  end

  it "cancels a reservation" do
    reservation = Reservation.create!(user_id: user.id, start_time: start_time)
    post '/receiver', cancel_params
    last_response.body.should == "OK"
    Reservation.count == 1
    reservation.reload.deleted_at.should_not be_nil
  end
end
