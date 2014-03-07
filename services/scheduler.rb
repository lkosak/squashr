require 'active_support/core_ext/date/calculations'

class Scheduler
  def self.currently_bookable?(start_time)
    start_time > Time.now && start_time < self.cutoff_asof(Time.now)
  end

  def self.cutoff_asof(time)
    if time.hour < 2
      Date.today.end_of_day
    else
      Date.tomorrow.end_of_day
    end
  end
end
