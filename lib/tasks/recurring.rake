namespace :recurring do
  task :hourly => :environment do
    Rails.logger.info "Running Hourly Tasks"
    zones = ENV["TIMEZONES"].split(",") if ENV["TIMEZONES"].present?

    Task::Notifications::DailyUpcomingReminders.run! zones: zones

    Task::Notifications::DailyCompletionReminders.run! zones: zones

    Rails.logger.info "Finished Hourly Tasks"
  end
end