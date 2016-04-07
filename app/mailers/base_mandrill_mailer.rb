require "mandrill"

class BaseMandrillMailer < ActionMailer::Base
  default(
    from:     "Lale <info@lale.help>",
    reply_to: "Lale <info@lale.help>"
  )

  def default_merge_vars
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
      merge_vars.merge!(default_merge_vars)

      body = begin
        fetch_template(I18n.locale, merge_vars)
      rescue Mandrill::UnknownTemplateError
        fetch_template("en", merge_vars)
      end

      send_mail(email, subject, body)
    end
  end

  def subject
    tag     = I18n.t('mailers.subject-tag', default: "[Lale]")
    key     = [:mailers, :subject, mailer_name, action_name].join(?.)
    content = I18n.t!(key, default: I18n.t!(key, locale: :en))
    "#{tag} #{content}"
  end

  def content_type
    if Rails.application.config.mandrill_templates
      "text/html"
    else
      "text/plain"
    end
  end

  def fetch_template(lang, attributes)
    template = template_name(lang)

    merge_vars = attributes.map do |key, value|
      { name: key, content: value }
    end

    if Rails.application.config.mandrill_templates
      _template_from_mandrill(template, merge_vars)
    else
      _template_debug(template, attributes)
    end
  end

  def _template_debug(template, merge_vars)
    {
      locale: locale,
      template_name: template,
      merge_vars: merge_vars
    }.to_yaml
  end

  def _template_from_mandrill(template, merge_vars)
    mandrill      = Mandrill::API.new(ENV["SMTP_PASSWORD"])
    mandrill.templates.render(template, [], merge_vars)["html"]
  end

  def template_name(lang)
    scope = mailer_name.gsub(/_mailer/, "")
    "#{lang}/#{scope}/#{action_name}"
  end

end