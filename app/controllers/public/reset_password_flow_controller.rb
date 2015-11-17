class Public::ResetPasswordFlowController < ApplicationController
  skip_authorization_check
  layout 'public'

  def reset_password
  end

  def submit
    outcome = User::ResetPassword.run(params)
    redirect_to public_reset_password_confirmation_path
  end

  def confirmation
  end
end