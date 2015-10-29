#         table_name         | column_name
# ---------------------------+--------------
# user_feedbacks             | volunteer_id
# task_volunteer_assignments | volunteer_id
# user_identities            | volunteer_id
# system_events              | volunteer_id
# system_event_notifications | volunteer_id
class RenameVolunteerToUser < ActiveRecord::Migration
  def change
    rename_table :volunteers, :users
    rename_table :volunteer_identities, :user_identities
    rename_table :volunteer_feedbacks, :user_feedbacks

    rename_column :user_feedbacks, :volunteer_id, :user_id
    rename_column :task_volunteer_assignments, :volunteer_id, :user_id
    rename_column :user_identities, :volunteer_id, :user_id
    rename_column :system_events, :volunteer_id, :user_id
    rename_column :system_event_notifications, :volunteer_id, :user_id


  end
end
