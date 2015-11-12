class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

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

    can :create_supply, Circle do |circle|
      can?(:manage, circle) or
      user.working_group_roles.admin.for_circle(circle).exists?
    end

    can :create_group, Circle do |circle|
      can?(:manage, circle)
    end

    can :create_item, Circle do |circle|
      can?(:create_task, circle) or
      can?(:create_supply, circle)
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
    can :read, Supply do |task|
      can? :read, task.circle
    end

    can :manage, Supply do |task|
      task.organizers.include?(user) or
      can?(:manage, task.working_group) or
      can?(:manage, task.circle)
    end
    cannot :delete, Supply do |task|
      !task.persisted?
    end

    can :volunteer, Supply do |task|
      can?(:read, task)
    end
    cannot :volunteer, Supply do |task|
      task.complete? or task.volunteers.include?(user)
    end

    can :decline, Supply do |task|
      task.volunteers.include?(user)
    end


    can :complete, Supply do |task|
      task.due_date < Time.now and (
        task.volunteers.include?(user) or
        task.organizers.include?(user)
      ) or
      can?(:manage, task.working_group) or
      can?(:manage, task.circle)
    end
    cannot :complete, Supply do |task|
      task.complete?
    end

  end
end
