class MakeTimeDurationAnEnumForTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :duration_unit
  end
end
