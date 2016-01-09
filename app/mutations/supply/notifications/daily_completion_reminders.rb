class Supply::Notifications::DailyCompletionReminders < Mutations::Command
  DAYS_AFTER  = 1
  HOUR_OF_DAY = 8

  optional do
    array :zones, class: String
  end


  def execute
    Rails.logger.info "--- Sending daily completion reminders for supplies in timezones: #{zone_names}, supplies: #{supplies.map(&:id)}"
    supplies.each do |supply|
      Supply::Notifications::CompletionReminderEmail.run supply: supply
    end
  end


  private


  def supplies
    @supplies ||= begin
      Supply.
        not_completed.
        joins(:circle).
        joins(circle: :location).
        where(locations: {timezone: zone_names } ).
        where(due_date: zone_due_dates)
    end
  end


  def timezones
    @timezones ||= if zones.present?
      zones.map{ |tz| ActiveSupport::TimeZone[tz] }
    else
      ActiveSupport::TimeZone.all.select{ |tz| tz.now.hour == HOUR_OF_DAY }
    end
  end


  def zone_due_dates
    timezones.map{|tz| tz.today - DAYS_AFTER }.uniq
  end


  def zone_names
    timezones.map{|tz| tz.tzinfo.identifier }.uniq
  end
end