class Circle::AdminsController < ApplicationController
  include HasCircle
  before_action :ensure_logged_in

  before_action do
    authorize! :manage, current_circle
  end

  def show
    @form = Circle::UpdateForm.new(user: current_user, circle: current_circle)
  end

  def roles
  end

  def working_groups
  end

  def invite
  end


  helper_method def tab_class key
    'selected' if action_name == key
  end
end