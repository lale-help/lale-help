#
# Some notes on abilities
#
# - :manage represents ANY action on the object, not just crud.
#   https://github.com/CanCanCommunity/cancancan/wiki/defining-abilities
#
# - The ability rules further down in a file will override a previous one.
#   https://github.com/CanCanCommunity/cancancan/wiki/Ability-Precedence
#
# - Adding can rules do not override prior rules, but instead are logically or'ed.
#   Therefore, it is best to place the more generic rules near the top.
#   https://github.com/CanCanCommunity/cancancan/wiki/Ability-Precedence
#
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    #
    # Admin
    #

    can :read, ActiveAdmin::Page, :name => "Dashboard"
    can :manage_site do
      user.is_admin
    end

    #
    # Circles
    #

    can :create, Circle
    can :read,   Circle do |circle|
      circle.has_active_user?(user)
    end

    can :manage, Circle do |circle|
      circle.has_active_user?(user) && circle.admins.include?(user)
    end

    can :create_task, Circle do |circle|
      can?(:manage, circle) or
      user.working_group_roles.admin.for_circle(circle).exists?
    end
    cannot :create_task, Circle do |circle|
      circle.working_groups.empty?
    end

    can :create_supply, Circle do |circle|
      can?(:manage, circle) or
      user.working_group_roles.admin.for_circle(circle).exists?
    end
    cannot :create_supply, Circle do |circle|
      circle.working_groups.empty?
    end

    can :create_item, Circle do |circle|
      can?(:create_task, circle) or
      can?(:create_supply, circle)
    end
    cannot :create_item, Circle do |circle|
      !can?(:create_task, circle)
    end

    can :create_project, Circle do |circle|
      can?(:manage, circle) or
      user.working_group_roles.admin.for_circle(circle).exists? or
      circle.working_groups.any? { |wg| can?(:manage, wg) }
    end
    cannot :create_project, Circle do |circle|
      circle.working_groups.empty?
    end

    #
    # Circle::Role
    #

    can :delete, Circle::Role do |role|
      circle = role.circle
      can?(:manage, circle)
      if role.role_type == 'circle.admin'
        can?(:manage, circle) && circle.active_admins.count > 1
      else
        can?(:manage, circle)
      end
    end

    #
    # Users
    #

    can :read, User do |member, circle|
      member.id == user.id ||
      (can?(:read, circle) &&
        (user.working_group_roles.admin.for_circle(circle).exists? ||
          circle.admins.include?(user) ||
          member.public_profile?))
    end

    #
    # Working Groups
    #

    can :manage, WorkingGroup do |wg|
      can?(:manage, wg.circle) 
      # ||
      # FIXME
      #wg.admins.active.include?(user)
    end

    can :read, WorkingGroup do |wg|
      if wg.is_private?
        can?(:manage, wg.circle) ||
          wg.users.include?(user)
      else
        can?(:read, wg.circle)
      end
    end

    can :create_task, WorkingGroup do |wg|
      can?(:manage, wg)
    end

    can :join, WorkingGroup do |wg|
      can?(:read, wg)
    end
    cannot :join, WorkingGroup do |wg|
      wg.users.include?(user)
    end

    can :leave, WorkingGroup do |wg|
      cannot?(:join, wg)
    end
    cannot :leave, WorkingGroup do |wg|
      can?(:join, wg)
    end

    #
    # Tasks
    #

    can :read, Task do |task|
      can?(:read, task.working_group)
    end

    can :manage, Task do |task|
      task.organizers.include?(user) or
      can?(:manage, task.working_group) or
      can?(:manage, task.circle)
    end
    cannot :delete, Task do |task|
      !task.persisted?
    end

    can :volunteer, Task do |task|
      can?(:read, task)
    end
    cannot :volunteer, Task do |task|
      task.complete? or task.volunteers.include?(user)
    end

    can :decline, Task do |task|
      task.volunteers.include?(user)
    end
    cannot :decline, Task do |task|
      task.complete?
    end

    can :invite_to, Task do |task|
      can?(:manage, task)
    end
    cannot :invite_to, Task do |task|
      task.complete?
    end


    can :complete, Task do |task|
      task.due_date < Time.now and (
        task.volunteers.include?(user) or
        task.organizers.include?(user)
      ) or
      can?(:manage, task.working_group) or
      can?(:manage, task.circle)
    end
    cannot :complete, Task do |task|
      task.complete?
    end


    can :reopen, Task do |task|
      task.complete? and ((
      task.volunteers.include?(user) or
          task.organizers.include?(user)
      ) or
          can?(:manage, task.working_group) or
          can?(:manage, task.circle))
    end
    cannot :reopen, Task do |task|
      task.incomplete?
    end

    can :clone, Task do |task|
      # can? :create_task, task.circle
      can?(:create_task, task.working_group)
    end

    #
    # Supply
    #

    can :read, Supply do |supply|
      can?(:read, supply.working_group)
    end

    can :manage, Supply do |supply|
      supply.organizers.include?(user) or
      can?(:manage, supply.working_group) or
      can?(:manage, supply.circle)
    end
    cannot :delete, Supply do |supply|
      !supply.persisted?
    end

    can :volunteer, Supply do |supply|
      can?(:read, supply)
    end
    cannot :volunteer, Supply do |supply|
      supply.complete? or supply.volunteers.include?(user)
    end

    can :decline, Supply do |supply|
      supply.volunteers.include?(user)
    end

    can :volunteer, Supply do |supply|
      can?(:read, supply)
    end
    cannot :volunteer, Supply do |supply|
      supply.complete? or supply.volunteers.present?
    end

    can :decline, Supply do |supply|
      supply.volunteers.include?(user)
    end
    cannot :decline, Supply do |supply|
      supply.complete? or supply.volunteers.empty?
    end

    can :complete, Supply do |supply|
      supply.due_date < Time.now and (
        supply.volunteers.include?(user) or
        supply.organizers.include?(user)
      ) or
      can?(:manage, supply.working_group) or
      can?(:manage, supply.circle)
    end
    cannot :complete, Supply do |supply|
      supply.complete?
    end

    can :invite_to, Supply do |supply|
      can?(:manage, supply)
    end
    cannot :invite_to, Supply do |supply|
      supply.complete? || supply.volunteer.present?
    end
    can :reopen, Supply do |supply|
      supply.complete? and ((
      supply.volunteers.include?(user) or
          supply.organizers.include?(user)
      ) or
          can?(:manage, supply.working_group) or
          can?(:manage, supply.circle))
    end
    cannot :reopen, Supply do |supply|
      supply.incomplete?
    end

    #
    # Comments
    #

    can :create, Comment do |comment|
      user.circles.include?(comment.task.circle)
    end

    #
    # Projects
    #

    can :manage, Project do |project|
      can?(:manage, project.circle) or can?(:manage, project.working_group)
    end
    cannot :manage, Project do |project|
      cannot?(:manage, project.working_group)
    end

    can :read, Project do |project|
      can?(:manage, project.circle) or can?(:read, project.working_group)
    end
    cannot :read, Project do |project|
      cannot?(:read, project.working_group)
    end

  end
end
