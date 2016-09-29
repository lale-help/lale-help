class UserBadgeCell < ::ViewModel

  delegates :controller, :can?

  include LinksHelper

  alias :user :model

  # default
  # def show
  #   render
  # end

  # needed in the user_icon partial
  def current_user
    @options[:current_user]
  end

  # needed in the user_icon partial
  def current_circle
    @options[:current_circle]
  end

  def user_name
    can_see_user? ? link_to_user(user) : user.name
  end

  def can_see_user?
    # FIXME use cancan rules here. the following lets an admin see the user, despite him having a private profile
    # can?(:read, user, current_circle) ? link_to_user(user) : user.name
    user.public_profile?
  end

  def user_icon
    cell(:user_icon, user, link: can_see_user?, circle: current_circle)
  end

  def user_badge_attributes
    {}
  end

end
