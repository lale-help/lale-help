require "mandrill"

class BaseMandrillMailer < ActionMailer::Base
  default(
    from:     "Lale <info@lale.help>",
    reply_to: "Lale <info@lale.help>"
  )

  def defaule_merge_vars
    {
      "CURRENT_YEAR" => Time.now.year,
      "LIST:COMPANY" => "Lale"
    }
  end


  private

  def send_mail(email, subject, body)
    mail(to: email, subject: subject, body: body, content_type: content_type)
  end

  def build_message lang, email, &block
    I18n.with_locale(lang) do
      merge_vars = block.call
      merge_vars.merge!(defaule_merge_vars)
      body       = fetch_template(merge_vars)
      send_mail(email, subject, body)
    end
  end

  def subject
    tag     = I18n.t('mailers.subject-tag', default: "[Lale]")
    content = I18n.t!([:mailers, :subject, mailer_name, action_name].join(?.))
    "#{tag} #{content}"
  end


  def content_type
    if Rails.application.config.mandrill_templates
      "text/html"
    else
      "text/plain"
    end
  end


  def fetch_template(attributes)
    merge_vars = attributes.map do |key, value|
      { name: key, content: value }
    end

    if Rails.application.config.mandrill_templates
      _template_from_mandrill(merge_vars)
    else
      _template_debug(attributes)
    end
  end

  def _template_debug merge_vars
    {
      locale: locale,
      template_name: template_name,
      merge_vars: merge_vars
    }.to_yaml
  end

  def _template_from_mandrill(merge_vars)
    mandrill      = Mandrill::API.new(ENV["SMTP_PASSWORD"])
    mandrill.templates.render(template_name, [], merge_vars)["html"]
  end

  def template_name
    scope = mailer_name.gsub(/_mailer/, "")
    "#{I18n.locale}/#{scope}/#{action_name}"
  end

end