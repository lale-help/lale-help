class EnsureActiveUser

  delegate :request, :redirect_to,
    :current_user, :current_circle, :try,
    :pending_member_page_path, :public_circle_inactive_circle_membership_path,
    to: :controller

  def self.before(controller)
    new.before(controller)
  end

  attr_reader :controller

  def before(controller)
    @controller = controller
    return unless current_user && try(:current_circle)
    if current_circle.has_active_user?(current_user) || on_info_path?
      return
    else
      redirect_to info_path
    end
  end

  private

  def on_info_path?
    request.fullpath == info_path
  end
  
  def info_path
    public_circle_inactive_circle_membership_path(current_circle, status: current_user_status)
  end

  def current_user_status
    current_user.circle_roles.find_by(circle: current_circle).status.to_sym
  end

end