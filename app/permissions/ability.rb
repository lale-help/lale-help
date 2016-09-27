#
# Some notes on abilities
#
# - :manage represents ANY action on the object, not just crud.
#   https://github.com/CanCanCommunity/cancancan/wiki/defining-abilities
#
# - Adding can rules do not override prior rules, but instead they are logically or'ed.
#   Therefore, it is best to place the more generic rules near the top.
#   https://github.com/CanCanCommunity/cancancan/wiki/Ability-Precedence
#
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new


    add_permissions FileUpload, user

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

    can :create, Circle # any user can create a circle!

    can :read, Circle do |circle|
      circle.users.active.include?(user)
    end

    can :manage, Circle do |circle|
      circle.admins.active.include?(user)
    end

    can [:create_task, :create_supply, :create_project, :create_item], Circle do |circle|
      circle.admins.active.include?(user)
    end
    cannot [:create_task, :create_supply, :create_project, :create_item], Circle do |circle|
      wgs = circle.working_groups.active
      wgs.empty? || wgs.none? { |wg| can?(:create_item, wg) }
    end

    #
    # Circle::Role
    #

    can :delete, Circle::Role do |role|
      circle = role.circle
      if (role.role_type == 'circle.admin') && role.active?
        can?(:manage, circle) && circle.admins.active.count > 1
      else
        can?(:manage, circle)
      end
    end

    #
    # Users
    #
    can :manage, User do |the_user|
      user == the_user
    end

    can :read, User do |member, circle|
      member.id == user.id ||
      (can?(:read, circle) &&
        (user.working_group_roles.admin.for_circle(circle).exists? ||
          circle.admins.include?(user) ||
          member.public_profile?))
    end

    can :block, User do |member, circle|
      can?(:manage, circle) && circle.has_active_user?(member)
    end
    can :unblock, User do |member, circle|
      can?(:manage, circle) && circle.has_blocked_user?(member)
    end
    cannot [:block, :unblock], User do |member, circle|
      member == user
    end

    #
    # Working Groups
    #

    can :manage, WorkingGroup do |wg|
      can?(:manage, wg.circle) || wg.active_admins.include?(user)
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
    # the can(:manage) block above allows all actions on the WG
    # **must** use cannot blocks to restrict the permissions again.
    cannot [:create_task, :create_supply, :create_item, :create_project], WorkingGroup do |wg|
      wg.disabled?
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

    can :assign_volunteers, Task do |task, assignees|
      can(:manage, task) && assignees.all? do |assignee|
        Ability.new(assignee).can?(:read, task)
      end
    end
    cannot :assign_volunteers, Task do |task, assignees|
      task.complete? or assignees.any? { |assignee| task.volunteers.include?(assignee) }
    end

    can :decline, Task do |task|
      task.volunteers.include?(user)
    end
    cannot :decline, Task do |task|
      task.complete?
    end

    can [:invite_to, :assign, :unassign], Task do |task|
      can?(:manage, task)
    end
    cannot [:invite_to, :assign, :unassign], Task do |task|
      cannot?(:manage, task) || task.complete?
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

    can :create, Comment, Taskable do |comment, item, circle|
      user.circles.include?(circle)
    end

    can :create, Comment, User do |comment, member, circle|
      can?(:manage, circle)
    end

    can :read, Comment, User do |comment, member, circle|
      can?(:manage, circle)
    end

    can :update, Comment, Taskable do |comment, item, circle|
      comment.commenter_id == user.id
    end

    can :update, Comment, User do |comment, member, circle|
      comment.commenter_id == user.id
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
    cannot :complete, Project do |project|
      project.complete?
    end
    cannot :reopen, Project do |project|
      project.open?
    end

    #
    # Sponsors and Sponsorships
    #
    can :read, Sponsor do
      # required for the sponsor files to be shown
      true
    end

  end

  def add_permissions model_klass, user
    permissions = model_klass.const_get :Abilities
    permissions.apply(self, user)
  end

end
