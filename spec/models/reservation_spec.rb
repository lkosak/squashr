require 'spec_helper'

describe Reservation do
  let(:valid_start_time) { DateTime.new(2014, 1, 1, 8, 15) }
  let(:invalid_start_time) { DateTime.new(2014, 1, 1, 8, 36) }

  describe "validations" do
    it "is invalid without a start time" do
      Reservation.new(start_time: nil).should_not be_valid
    end

    it "is invalid with an improper start time" do
      Reservation.new(start_time: invalid_start_time).should_not be_valid
    end

    it "is valid with a valid start time" do
      Reservation.new(start_time: valid_start_time).should be_valid
    end

    it "is invalid with an unsupported status" do
      reservation = Reservation.new(start_time: valid_start_time, status: 'delicious')
      reservation.should_not be_valid
    end
  end

  describe "defaults" do
    it "defaults to status pending" do
      Reservation.new.status.should == Reservation::STATUS_PENDING
    end

    it "accepts a custom starting status" do
      Reservation.new(status: Reservation::STATUS_BOOKED).status.should ==
        Reservation::STATUS_BOOKED
    end
  end

  describe ".find_by_start_time" do
    it "finds a reservation for a user id and start time" do
      reservation = Reservation.create(user_id: 1, start_time: valid_start_time)
      result = Reservation.find_by_start_time(1, valid_start_time)
      result.id.should == reservation.id
    end

    it "ignores reservations by other users" do
      reservation = Reservation.create(user_id: 2, start_time: valid_start_time)
      result = Reservation.find_by_start_time(1, valid_start_time)
      result.should be_nil
    end

    it "ignores non-matching start times" do
      reservation = Reservation.create(user_id: 1, start_time: valid_start_time)
      result = Reservation.find_by_start_time(1, valid_start_time + 45)
      result.should be_nil
    end
  end
end
