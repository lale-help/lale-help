#
# This is an association extension as described in http://goo.gl/DHdXzd.
# 
# It enables calls like 
# 
#   circle.users.active
#   circle.volunteers.pending
#   project.admins.active
#   [...]
#   
# although the status is not on the users table but on the role table for the main model
#
module UserAssociationExtension

  def method_missing(name)
    if role_class.statuses.include?(name)
      with_status(name)
    else
      super
    end
  end

  def with_status(status)
    # Specific example:
    # a_circle.admins.where(circle_roles: { status: 1 } )
    owner_instance.send(association_name).where(role_condition(status))
  end

  private

  # the class that owns the association (Circle, Project, WorkingGroup)
  def owner_instance
    proxy_association.owner
  end

  # returns the query condition for finding the correct role. 
  # examples:
  # circle_roles: { status: 1 }
  # project_roles: { status: 0 }
  def role_condition(status)
    { "#{role_class.table_name}": { status: map_status_to_id(status) } }
  end

  # the name that follows the has_many definition in the owner class,
  # i.e. users, admins, volunteers, ...
  def association_name
    proxy_association.reflection.delegate_reflection.name
  end

  # will return Circle::Role, Project::Role etc.
  def role_class
    owner_instance.class.const_get('Role')    
  end

  # map the status symbold to the correct integer for SQL querying
  def map_status_to_id(status) 
    role_class.statuses.fetch(status)
  end

end
