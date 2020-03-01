class ChangeTaskDateTimeFields < ActiveRecord::Migration

  class Task < ActiveRecord::Base
  end

  def up
    # change schema
    rename_column :tasks, :scheduled_time_type,  :scheduling_type
    rename_column :tasks, :scheduled_time_start, :start_time
    rename_column :tasks, :scheduled_time_end,   :due_time

    change_column :tasks, :start_time, :string, null: true
    change_column :tasks, :due_time, :string, null: true

    add_column :tasks, :start_date, :date, null: true

    # migrate data

    # at tasks have a due date & time set. but start_time needs to go to due_time
    Task.where(scheduling_type: 'at').update_all("due_time=start_time, start_time=NULL")

    # on_date tasks are like at tasks, but they never have a time. We make them at tasks, as well.
    Task.where(scheduling_type: 'on_date').update_all(
      start_time: nil, due_time: nil,
      scheduling_type: 'at'
    )

    Task.where(scheduling_type: 'between').update_all("start_date=due_date")
  end

  def down
    # change schema
    rename_column :tasks, :scheduling_type, :scheduled_time_type
    rename_column :tasks, :start_time, :scheduled_time_start
    rename_column :tasks, :due_time, :scheduled_time_end
    change_column :tasks, :scheduled_time_start, :string, null: false, default: '0:00'
    change_column :tasks, :scheduled_time_end, :string, null: false, default: '0:00'
    remove_column :tasks, :start_date

    # migrating data back isn't possible, it's lossy
  end
end
