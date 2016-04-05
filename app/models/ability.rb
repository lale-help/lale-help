class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Admin
    can :read, ActiveAdmin::Page, :name => "Dashboard"
    can :manage_site do
      user.is_admin
    end

    # Circles
    can :create, Circle
    can :read,   Circle do |circle|
      circle.users.active.include? user
    end

    can :manage, Circle do |circle|
      circle.admins.active.include? user
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



    can :delete, Circle::Role do |role|
      can?(:manage, role.circle)
      if role.role_type == 'circle.admin'
        can?(:manage, role.circle) &&
        role.circle.admins.active.count > 1
      else
        can?(:manage, role.circle)
      end
    end

    # Users
    can :read, User do |member, circle|
      member.id == user.id ||
      (can?(:read, circle) &&
        (user.working_group_roles.admin.for_circle(circle).exists? || 
          circle.admins.include?(user) ||
          member.public_profile?))
    end


    # Work Groups
    can :read, WorkingGroup do |wg|
      if wg.is_private?
        can?(:manage, wg.circle) ||
          wg.users.include?(user)
      else
        can?(:read, wg.circle)
      end
    end

    can :manage, WorkingGroup do |wg|
      can?(:manage, wg.circle) ||
      wg.admins.active.include?(user)
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


    # Tasks
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


    # Supply
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





    # Comments
    can :create, Comment do |comment|
      user.circles.include?(comment.task.circle)
    end



    # Projects
    can :read, Project do |project|
      can?(:manage, project.circle) or can?(:read, project.working_group)
    end

    can :manage, Project do |project|
      can?(:manage, project.circle) or 
        project.circle.working_groups.any? { |wg| can?(:manage, wg) }
    end

  end
end
