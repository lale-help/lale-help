class MailLoggerObserver
  def self.delivered_email(mail)
    Sidekiq::Logging.logger.info("[SENT EMAIL] to: #{mail.to}, subject: #{mail.subject}")
  end
end

ActionMailer::Base.register_observer(MailLoggerObserver)
