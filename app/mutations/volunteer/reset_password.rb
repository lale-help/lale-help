class Volunteer::ResetPassword < Mutations::Command
  required do
    string :email
  end

  def execute
    identity = Volunteer::Identity.find_by!(email: email)
    Token.reset_password.for_user_id(identity.volunteer_id).update_all(active: false)
    token    = Token.reset_password.create! context: { user_id: identity.volunteer_id }
    UserMailer.forgot_password(identity.volunteer, token).deliver_now

  rescue ActiveRecord::RecordNotFound
    add_error(:volunteer, :not_found)
  end
end
