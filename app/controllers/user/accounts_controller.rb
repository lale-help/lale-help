class User::AccountsController < ApplicationController

  skip_authorization_check, only: :switch_circle

  before_action :ensure_logged_in
  before_action :ensure_circle
  before_action { load_user_instance }

  layout 'internal'

  def change_password
    authorize! :edit, @user, current_circle
  end

  def update_password
    authorize! :edit, @user, current_circle
    outcome =  User::UpdatePassword.run({user: @user}, params)
    if outcome.success?
      redirect_to circle_member_url(current_circle, @user), notice: t("users.flash.password_reset_success")
    else
      @errors = outcome.errors
      render :change_password
    end
  end

  def switch_circle
    if can? :read, Circle.find(params[:circle_id].to_i)
      session[:circle_id] = params[:circle_id].to_i
      redirect_to circle_path(session[:circle_id])
    else
      redirect_to root_path, error: t('flash.user.account.circle_invalid')
    end
  end

  helper_method def current_circle
    if current_user.present?
      if session[:circle_id].present?
        Circle.find(session[:circle_id])
      else
        current_user.primary_circle
      end
    end
  end

  helper_method def errors
    @errors ||= Errors.new
  end

  private

  def load_user_instance
    @user = User.find(params[:id] || params[:account_id])
  end

end
