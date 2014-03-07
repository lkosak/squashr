require 'spec_helper'

describe Valet do
  let(:user) { User.new(id: 1) }
  let(:start_time) { DateTime.new(2014, 1, 1, 8, 15) }

  let(:book_instruction) do
    double('Instruction', action: :book, start_time: start_time)
  end

  let(:cancel_instruction) do
    double('Instruction', action: :cancel, start_time: start_time)
  end

  let(:reservation) { double('Reservation', saved?: true) }

  describe "booking" do
    it "creates a reservation for the specified user and start time" do
      Reservation.should_receive(:create!).
                  with(user_id: user.id, start_time: start_time).
                  and_return(reservation)
      Valet.new(user, book_instruction).run
    end

    it "raises an exception if the reservation cannot be created" do
      reservation.stub(saved?: false, errors: [])
      Reservation.should_receive(:create!).and_return(reservation)
      expect {
        Valet.new(user, book_instruction).run
      }.to raise_error Valet::BookingFailed
    end
  end

  describe "cancelling" do
    it "cancels a reservation for the specified user and start time" do
      Reservation.stub(:find_by_start_time).
                  with(user.id, start_time).
                  and_return(reservation)
      reservation.should_receive(:cancel!)
      Valet.new(user, cancel_instruction).run
    end

    it "raises an exception if the reservation can't be found" do
      Reservation.stub(:find_by_start_time).and_return(nil)

      expect {
        Valet.new(user, cancel_instruction).run
      }.to raise_error Valet::ReservationNotFound
    end

    it "raises an exception if the reservation can't be canceled" do
      reservation.stub(:cancel!).and_raise
      Reservation.stub(:find_by_start_time).and_return(reservation)

      expect {
        Valet.new(user, cancel_instruction).run
      }.to raise_error Valet::CancelFailed
    end
  end
end
