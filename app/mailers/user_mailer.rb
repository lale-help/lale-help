class UserMailer < BaseMandrillMailer
  def forgot_password(user, token)
    subject = "Lale.help - Did you forget something?"
    merge_vars = {
      "FIRST_NAME" => user.first_name,
      "LAST_NAME" => user.last_name,
      "RESET_PASSWORD_URL" => handle_token_url(token.code)
    }
    body = mandrill_template("forgot password", "en", merge_vars)

    send_mail(user.email, subject, body)
  end
end