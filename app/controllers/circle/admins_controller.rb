class Circle::AdminsController < ApplicationController
  include HasCircle
  before_action :ensure_logged_in

  before_action do
    authorize! :manage, current_circle
  end

  def show
    @form = Circle::UpdateBasicSettingsForm.new(user: current_user, circle: current_circle)
  end

  def roles
  end

  def working_groups
  end

  def invite
    @pending_members = current_circle.pending_members.order('created_at DESC')
  end

  def extended_settings
    @form = Circle::UpdateExtendedSettingsForm.new(user: current_user, circle: current_circle)
  end
  
  def activate_member
    outcome = Circle::ActivateMember.run(params)
    head (outcome ? :ok : :unprocessable_entity)
  end

  helper_method def tab_class key
    (action_name == key) ? "#{key} selected" : key
  end
end