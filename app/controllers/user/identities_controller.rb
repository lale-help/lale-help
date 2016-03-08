class User::IdentitiesController < ApplicationController
  skip_authorization_check
  layout 'public'

  def new
    @hide_signed_in_status = true
    @form = User::Create.new
  end

  def create
    @form = User::Create.new params[:user]
    outcome = @form.submit

    if outcome.success?
      login(outcome.result)
      redirect_to public_circles_path

    else
      errors.add outcome.errors
      render :new
    end
  end
end


