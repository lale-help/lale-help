class AddDatesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :start_date, :date
    add_column :projects, :due_date, :date
  end
end
