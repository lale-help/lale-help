class UserIconCell < ::ViewModel

  include Refile::AttachmentHelper

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

  def profile_image_present?
    user.profile_image.present?
  end

  def user_initials_or_blank
    # for the container not to collapse and layout not to break, it needs to contain something, so I'm adding the &nbsp;
    profile_image_present? ? '&nbsp;': user.initials
  end

  def user_icon_attrs
    attrs = { href: href, class: classes }
    if profile_image_present?
      attrs[:style] = "background-image: url(#{profile_image_url})"
    end
    attrs
  end

  # FIXME return correct size (30 or 50 px)
  def profile_image_url
    attachment_url(user, :profile_image, :fill, 30, 30, format: "jpg")
  end

end
