require 'active_support/core_ext/date/calculations'
require 'gateways/xpiron'

class Scheduler
  def initialize(asof=nil)
    @asof = asof || Time.now
  end

  def book_all
    Reservation.pending.each do |reservation|
      next unless currently_bookable?(reservation.start_time)

      user = User.first(id: reservation.user_id)
      xpiron = Gateways::Xpiron.new(user.xpiron_username,
                                            user.xpiron_password)
      xpiron.book(reservation.start_time)
    end
  end

  private

  def currently_bookable?(start_time)
    start_time > @asof && start_time < cutoff
  end

  def cutoff
    if @asof.hour < 2
      Date.today.end_of_day
    else
      Date.tomorrow.end_of_day
    end
  end
end
