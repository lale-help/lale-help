class Task::Notifications::DailyReminders < Mutations::Command

  DAYS_UNTIL_TASK = 1
  HOUR_OF_DAY     = 8

  optional do
    array :zones, class: String
  end


  def execute
    tasks.each do |task|
      Task::Notifications::ReminderEmail.run task: task
    end
  end


  private


  def tasks
    @tasks ||= begin
      zone_names     = timezones.map{|tz| tz.tzinfo.identifier }
      zone_due_dates = timezones.map{|tz| tz.today + DAYS_UNTIL_TASK }.uniq

      Task.
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

end