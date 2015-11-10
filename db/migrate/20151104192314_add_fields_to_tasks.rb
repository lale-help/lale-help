class AddFieldsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :volunteer_count_required, :integer
    add_column :tasks, :time_requirement, :json

    add_column :tasks, :duration,      :integer, default: 1
    add_column :tasks, :duration_unit, :string , default: 'hour'

    add_column :tasks, :scheduled_time_type,  :string
    add_column :tasks, :scheduled_time_start, :string
    add_column :tasks, :scheduled_time_end,   :string
  end
end
