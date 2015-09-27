class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Volunteer.new

    # Circles
    can :read, Circle
    can :create, Circle unless user.circle.present?
    can [:update, :destroy], Circle, admin: user

    # Work Groups
    can :read, WorkingGroup, circle: user.circle
    can [:create, :update, :destroy], WorkingGroup, circle: { admin: user }

    # Tasks
    can :read, Task, working_group: { circle: user.circle }
    can [:create, :update, :destroy], Task, working_group: { circle: { admin: user } }
    can :volunteer, Task, working_group: { circle: user.circle }
    cannot :volunteer, Task, volunteer_assignments: { volunteer: user }
    can :complete, Task, volunteer_assignments: { volunteer: user }
  end
end
