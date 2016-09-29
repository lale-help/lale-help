class UserIconCell < ::ViewModel

  # this is the default
  # def show
  #   render
  # end

  alias :user :model

  delegate :can?, to: :ability

  def href
    if link? && can?(:read, user, circle)
      circle_member_path(circle, user)
    end
  end

  def classes
    classes = []
    if user.lale_bot?
      classes << 'lale-bot'
    else
      classes << 'accredited' if current_user_role.accredited?
    end
  end

  def circle
    @options[:circle]
  end

  def current_user_role
    user.circle_volunteer_roles.find_by(circle: circle)
  end

  def link?
    @options[:link]
  end

  def ability
    @ability ||= Ability.new(user)
  end

end
