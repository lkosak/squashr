require 'spec_helper'

describe Scheduler do
  let(:start_time1) { DateTime.new(2014, 1, 20, 8, 15) }
  let(:start_time2) { DateTime.new(2014, 1, 20, 9, 00) }
  let(:xpiron) { double('Xpiron') }

  describe "bookings" do
    let!(:user) do
      User.create(name: 'Test', xpiron_username: 'test', xpiron_password: 'test')
    end
    let!(:reservation1) do
      Reservation.create(user_id: user.id, start_time: start_time1)
    end
    let!(:reservation2) do
      Reservation.create(user_id: user.id, start_time: start_time2)
    end

    it "books all new reservations" do
      Gateways::Xpiron.stub(:new).
                       with(user.xpiron_username, user.xpiron_password).
                       and_return(xpiron)
      xpiron.should_receive(:book).with(start_time1)
      xpiron.should_receive(:book).with(start_time2)
      Scheduler.new(DateTime.new(2014, 1, 20)).book_all
    end
  end
end
