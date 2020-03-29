class AddNotifyOnToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :notify_on_task_comment, :boolean, default: true
    add_column :circles, :notify_on_task_change, :boolean, default: true
    Circle.update_all(notify_on_task_comment: true, notify_on_task_change: true)
  end
end
