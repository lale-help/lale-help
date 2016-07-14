class AddUniqueIndicesOnUserRoles < ActiveRecord::Migration

  #
  # used the consistency_fail gem to find some useful unique indices.
  # 
  def change
    # uniqueness for roles per user 
    add_index :circle_roles,        [:user_id, :role_type, :circle_id], unique: true
    add_index :project_roles,       [:user_id, :role_type, :project_id], unique: true
    add_index :task_roles,          [:user_id, :role_type, :task_id], unique: true
    add_index :supply_roles,        [:user_id, :role_type, :supply_id], unique: true
    add_index :working_group_roles, [:user_id, :role_type, :working_group_id], unique: true, name: 'index_user_id_and_role_type_and_working_group_id'

    # uniqueness for name within containing entity
    add_index :projects,       [:name, :working_group_id], unique: true
    add_index :working_groups, [:name, :circle_id], unique: true

    # single-field uniqueness
    add_index :sponsors, :name, unique: true
    add_index :user_identities, :email, unique: true
  end
end
