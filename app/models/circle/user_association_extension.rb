#
# This is an association extension as described in http://goo.gl/DHdXzd.
#
# It enables calls like
#
#   circle.users.active
#   circle.volunteers.pending
#   circle.admins.blocked
#
# although the status is not stored on User but on Circle::Role
#
class Circle
  module UserAssociationExtension

    Circle::Role.statuses.keys.each do |status|
      define_method(status) do
        with_status(status)
      end
    end

    def with_status(status)
      # Example: a_circle.admins.where(circle_roles: { status: 1 } )
      owner_instance.send(association_name).where(role_condition(status))
    end

    private

    # the class that owns the association (Circle, Project, WorkingGroup)
    def owner_instance
      proxy_association.owner
    end

    # returns the query condition for finding the correct role.
    def role_condition(status)
      { circle_roles: { status: map_status_to_id(status) } }
    end

    # the name that follows the has_many definition in the owner class,
    # i.e. users, admins, volunteers, ...
    def association_name
      proxy_association.reflection.delegate_reflection.name
    end

    # map the status symbold to the correct integer for SQL querying
    def map_status_to_id(status)
      Circle::Role.statuses.fetch(status)
    end

  end
end