class User::AccountController < ApplicationController
  skip_authorization_check
  layout 'internal'

  def edit
    @form = User::Update.new(current_user.attributes, user: current_user)
  end

  def update
    @form = User::Update.new(params[:user], user: current_user)
    outcome = @form.submit
    errors.add outcome.errors
    render :edit
  end

  def reset_password
  end

  def update_password
    outcome =  User::UpdatePassword.run({user: current_user}, params)
    if outcome.success?
      redirect_to current_user.circles.first, notice: t("users.flash.password_reset_success")
    else
      @errors = outcome.errors
      render :reset_password
    end
  end

  helper_method def current_circle
    current_user.circles.first
  end

  helper_method def errors
    @errors ||= Errors.new
  end


end