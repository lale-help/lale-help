class EnsureActiveUser

  delegate :request, :redirect_to,
    :current_user, :current_circle, :try,
    :pending_member_page_path, :public_circle_inactive_circle_membership_path, :circle_path,
    to: :controller

  def self.before(controller)
    new.before(controller)
  end

  attr_reader :controller

  def before(controller)
    @controller = controller
    return unless current_user && try(:current_circle)
    if !user_is_circle_member? # user has no role in circle
      redirect_to circle_path(current_user.primary_circle)
    elsif current_circle.has_active_user?(current_user) || on_info_path?
      return
    else
      redirect_to info_path
    end
  end

  private

  def user_is_circle_member?
    current_user.role_for_circle(current_circle)
  end

  def on_info_path?
    request.fullpath == info_path
  end
  
  def info_path
    current_user_status && public_circle_inactive_circle_membership_path(current_circle, status: current_user_status)
  end

  def current_user_status
    current_user.role_for_circle(current_circle).try(:status)
  end

end