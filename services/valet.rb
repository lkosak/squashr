class Valet
  class Error < StandardError; end
  class ReservationNotFound < Error; end
  class BookingFailed < Error; end
  class CancelFailed < Error; end

  def initialize(user, instruction)
    @user = user
    @instruction = instruction
  end

  def run
    case @instruction.action
    when :book
      reservation = Reservation.create!(user_id: @user.id,
                                        start_time: @instruction.start_time,
                                        status: Reservation::STATUS_PENDING)

      unless reservation.valid?
        raise BookingFailed, reservation.errors
      end
    when :cancel
      reservation = Reservation.find_by_start_time(@user.id, @instruction.start_time)
      raise ReservationNotFound unless reservation
      reservation.deleted_at = Time.now

      unless reservation.save
        raise CancelFailed, reservation.errors
      end
    end
  end
end
