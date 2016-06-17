class UserBadgeCell < ::ViewModel
  
  delegate :can?, to: :ability

  include LinksHelper

  alias :user :model

  def show
    render
  end

  # needed in the user_icon partial
  def current_user
    @options[:current_user]
  end

  # needed in the user_icon partial
  def current_circle
    @options[:current_circle]
  end

  def user_link
    link_to_user(user)
  end

  def user_badge_attributes
    {}
  end

  def ability
    @ability ||= Ability.new(current_user)
  end

end
