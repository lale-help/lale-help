class User::ResetPassword < Mutations::Command
  required do
    string :email
  end

  def execute
    identity = User::Identity.find_by!(email: email)
    Token.reset_password.for_user_id(identity.user_id).update_all(active: false)
    token    = Token.reset_password.create! context: { user_id: identity.user_id }
    UserMailer.delay.forgot_password(identity.user, token)

  rescue ActiveRecord::RecordNotFound
    add_error(:user, :not_found)
  end
end
