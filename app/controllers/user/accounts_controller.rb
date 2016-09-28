class User::AccountsController < ApplicationController

  before_action :ensure_logged_in
  before_action :ensure_circle
  before_action { load_user_instance }
  before_action { authorize!(:edit, @user) }

  layout 'internal'

  def show
  end

  def edit
    @form = User::Update.new(user: @user)
  end

  def update
    @form = User::Update.new(params[:user], user: @user)
    outcome = @form.submit
    errors.add outcome.errors
    if outcome.success?
      flash[:notice] = t("flash.user.account.saved")
      redirect_to account_url
    else
      flash[:error] = t("flash.user.account.save-failed")
      render :edit
    end
  end

  def change_password
  end

  def update_password
    outcome =  User::UpdatePassword.run({user: @user}, params)
    if outcome.success?
      # FIXME redirect correctly; when admin edits this redirect may not make sense
      redirect_to @user.primary_circle, notice: t("users.flash.password_reset_success")
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

  # FIXME review if OK
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
