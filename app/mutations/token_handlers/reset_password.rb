# FIXME TokenHandlers::Login could handle this as well, it seems.
# Use that and delete this subtype.
class TokenHandlers::ResetPassword < TokenHandler
  def handle_token(token)
    identity = User::Identity.find_by(user_id: token.context['user_id'])
    controller.login(identity.user)
    controller.redirect_to account_reset_password_path
  end
end