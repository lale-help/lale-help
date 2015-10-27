class TokenHandlers::ResetPassword < TokenHandler
  def handle_token(token)
    identity = Volunteer::Identity.find_by(volunteer_id: token.context['user_id'])
    controller.login(identity.volunteer)
    controller.redirect_to account_reset_password_path
  end
end