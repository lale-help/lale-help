namespace :recurring do
  task :hourly => :environment do
    zones = ENV["TIMEZONES"].split(",") if ENV["TIMEZONES"].present?

    Task::Notifications::DailyReminders.run! zones: zones
  end
end