class Tasks::UserBadgeCell < ::ViewModel

  include LinksHelper

  alias :user :model

  delegate :can?, to: :ability

  def show
    render
  end

  def user_link
    link_to_user(user)
  end

  def task
    @options[:task]
  end

  def current_user
    @options[:current_user]
  end

  def current_circle
    task.circle
  end

  # FIXME fix cancan
  def user_badge_class
    can?(:decline, task) ? 'declinable' : ''
  end

  def ability
    @ability ||= Ability.new(current_user)
  end

end
