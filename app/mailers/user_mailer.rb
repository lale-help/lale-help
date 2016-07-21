class UserMailer < BaseMandrillMailer

  def forgot_password(user, token)
    build_message(user.language, user.email) do
      {
        "FIRST_NAME"         => user.first_name,
        "LAST_NAME"          => user.last_name,
        "RESET_PASSWORD_URL" => handle_token_url(token.code)
      }
    end
  end

  # sent to circle admins when new users want to join
  def account_activation(circle, user, token) 
    puts "RAILS_ENV ------------------------------------"
    puts Rails.env.inspect
    ap Rails.configuration.action_mailer.default_url_options
    ap Rails.configuration.action_controller.default_url_options
    puts "------------------------------------"
    build_message(user.language, user.email) do
      {
        "FIRST_NAME"          => user.first_name,
        "HELPER_CIRCLE"       => circle.name,
        "APPROVE_REQUEST_URL" => handle_token_url(token.code, 
          redirect: invite_circle_admin_url(circle)
        )
      }
    end
  end

  # sent to new circle member when account was activated
  def account_activated(circle, user)
    build_message(user.language, user.email) do
      {
        "FIRST_NAME"       => user.first_name,
        "HELPER_CIRCLE"    => circle.name,
        "CIRCLE_LOGIN_URL" => login_url
      }
    end
  end
end