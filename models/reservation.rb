require 'scheduler'

class Reservation
  include DataMapper::Resource

  STATUS_PENDING = 'pending'
  STATUS_BOOKED = 'booked'

  START_TIMES = %w{
    05:00
    05:30
    06:00
    06:45
    07:30
    08:15
    09:00
    09:45
    10:30
    11:15
    12:00
    12:45
    13:30
    14:15
    15:00
    15:45
    16:30
    17:15
    18:00
    18:45
    19:30
    20:15
    21:00
  }

  property :id, Serial
  property :user_id, Integer
  property :start_time, DateTime
  property :status, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, DateTime

  validates_with_method :validate_start_time

  def validate_start_time
    if self.start_time.nil?
      return [false, "Start time is required"}
    end

    if self.start_time.sec != 0 || self.start_time.usec != 0
      return [false, "Start time can't contain seconds"]
    end

    if START_TIMES.include?(self.start_time.strftime("%H:%M")
      return [false, "Invalid start time specified"]
    end

    true
  end

  def self.find_by_start_time(user_id, start_time)
    self.find(user_id: user_id, start_time: start_time)
  end
end

