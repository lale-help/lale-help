class RemoveJsonColumnFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :time_requirement
  end
end
