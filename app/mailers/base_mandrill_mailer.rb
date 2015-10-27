require "mandrill"

class BaseMandrillMailer < ActionMailer::Base
  default(
    from:     "Lale.help <info@lale.help>",
    reply_to: "Lale.help <info@lale.help>"
  )

  private

  def send_mail(email, subject, body)
    mail(to: email, subject: subject, body: body, content_type: "text/html")
  end

  def mandrill_template(template_name, locale, attributes)
    mandrill = Mandrill::API.new(ENV["SMTP_PASSWORD"])

    merge_vars = attributes.map do |key, value|
      { name: key, content: value }
    end

    template_name = "#{template_name} - #{locale}"

    mandrill.templates.render(template_name, [], merge_vars)["html"]
  end
end