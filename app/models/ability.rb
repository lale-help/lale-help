class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Circles
    can :read, Circle
    can :create, Circle unless user.circle.present?
    if user.circle
      can [:update, :destroy], Circle, admin: user

      # Work Groups
      can :read, WorkingGroup, circle_id: user.circle_id
      can [:create, :update, :destroy], WorkingGroup, circle: { admin: user }

      # Tasks
      can :read, Task, working_group: { circle_id: user.circle_id }
      can [:create, :update, :destroy], Task, working_group: { circle: { admin: user } }
      can :volunteer, Task, working_group: { circle: user.circle }
      cannot :volunteer, Task, volunteer_assignments: { user: user }
      can :complete, Task, volunteer_assignments: { user: user }, completed_at: nil
    end
  end
end
