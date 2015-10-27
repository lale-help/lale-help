class Volunteer::AccountController < ApplicationController
  skip_authorization_check
  layout 'circle_page'

  def edit

  end

  def reset_password
  end

  def update_password
    outcome =  Volunteer::UpdatePassword.run({volunteer: current_user}, params)
    if outcome.success?
      redirect_to current_user.circle, notice: t("volunteers.flash.password_reset_success")
    else
      @errors = outcome.errors
      render :reset_password
    end
  end
end