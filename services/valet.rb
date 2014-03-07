class Valet
  class Error < StandardError; end
  class ReservationNotFound < Error; end
  class BookingFailed < Error; end
  class CancelFailed < Error; end

  VALID_ACTIONS = [:book, :cancel]

  def initialize(user, instruction)
    @user = user
    @instruction = instruction
  end

  def run
    unless VALID_ACTIONS.include?(@instruction.action)
      raise "Invalid action specified: #{@instruction.action}"
    end

    self.send(@instruction.action)
  end

  private

  def book
    reservation = Reservation.create!(user_id: @user.id,
                                      start_time: @instruction.start_time)

    unless reservation.saved?
      raise BookingFailed, reservation.errors
    end
  end

  def cancel
    reservation = Reservation.find_by_start_time(@user.id, @instruction.start_time)
    raise ReservationNotFound unless reservation

    begin
      reservation.cancel!
    rescue => e
      raise CancelFailed, "#{e}: #{e.message}"
    end
  end
end
