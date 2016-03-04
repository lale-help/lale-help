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
  def account_activation(user)
    build_message(user.language, user.email) do
      {
        "FIRST_NAME"          => user.first_name,
        "HELPER_CIRCLE"       => user.primary_circle.name,
        "APPROVE_REQUEST_URL" => invite_circle_admin_url(user.primary_circle)
      }
    end
  end

  # sent to new circle member when account was activated
  def account_activated(user)
    build_message(user.language, user.email) do
      {
        "FIRST_NAME"       => user.first_name,
        "HELPER_CIRCLE"    => user.primary_circle.name,
        "CIRCLE_LOGIN_URL" => login_url
      }
    end
  end
end