class UserMailer < BaseMandrillMailer

  def forgot_password(user_id, token_code)
    user = User.find(user_id)
    build_message(user.language, user.email) do
      {
        "FIRST_NAME"         => user.first_name,
        "LAST_NAME"          => user.last_name,
        "RESET_PASSWORD_URL" => handle_token_url(token_code)
      }
    end
  end

  # sent to circle admins when new users want to join
  def account_activation(circle_id, user_id, token_code)
    circle = Circle.find(circle_id)
    user = User.find(user_id)
    build_message(user.language, user.email) do
      {
        "FIRST_NAME"          => user.first_name,
        "HELPER_CIRCLE"       => circle.name,
        "APPROVE_REQUEST_URL" => handle_token_url(token_code,
          redirect: invite_circle_admin_url(circle)
        )
      }
    end
  end

  # sent to new circle member when account was activated
  def account_activated(circle_id, user_id)
    circle = Circle.find(circle_id)
    user = User.find(user_id)
    build_message(user.language, user.email) do
      {
        "FIRST_NAME"       => user.first_name,
        "HELPER_CIRCLE"    => circle.name,
        "CIRCLE_LOGIN_URL" => login_url
      }
    end
  end
end
