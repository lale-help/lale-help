class UserMailer < BaseMandrillMailer
  def forgot_password(user, token)
    build_message(user.language, user.email) do
      {
        "FIRST_NAME" => user.first_name,
        "LAST_NAME" => user.last_name,
        "RESET_PASSWORD_URL" => handle_token_url(token.code)
      }
    end
  end
end