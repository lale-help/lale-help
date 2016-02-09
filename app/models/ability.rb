class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Admin
    can :read, ActiveAdmin::Page, :name => "Dashboard"

    # Circles
    can :create, Circle
    can :read,   Circle do |circle|
      circle.users.include? user
    end

    can :manage, Circle do |circle|
      circle.admins.include? user
    end

    can :create_task, Circle do |circle|
      can?(:manage, circle) or
      user.working_group_roles.admin.for_circle(circle).exists?
    end
    cannot :create_task, Circle do |circle|
      circle.working_groups.count == 0
    end

    can :create_supply, Circle do |circle|
      can?(:manage, circle) or
      user.working_group_roles.admin.for_circle(circle).exists?
    end
    cannot :create_supply, Circle do |circle|
      circle.working_groups.count == 0
    end

    can :create_group, Circle do |circle|
      can?(:manage, circle)
    end

    can :create_item, Circle do |circle|
      can?(:create_task, circle) or
      can?(:create_supply, circle)
    end
    cannot :create_item, Circle do |circle|
      !can?(:create_task, circle)
    end



    can :delete, Circle::Role do |role|
      can?(:manage, role.circle)
      if role.role_type == 'circle.admin'
        can?(:manage, role.circle) &&
        role.circle.admins.count > 1
      else
        can?(:manage, role.circle)
      end
    end

    # Users
    can :read, User do |user, circle|
      can?(:read, circle)
      unless user.working_group_roles.admin.for_circle(circle).exists?
        user.public_profile?
      end
    end


    # Work Groups
    can :read, WorkingGroup do |wg|
      can? :read, wg.circle
    end

    can :manage, WorkingGroup do |wg|
      can?(:manage, wg.circle) ||
      wg.admins.include?(user)
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
      can? :read, task.circle
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


    # Supply
    can :read, Supply do |supply|
      can? :read, supply.circle
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
  end
end
