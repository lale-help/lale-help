class AddDatesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :start_date, :date
    add_column :projects, :due_date, :date
    
    reversible do |dir|
      dir.up do
        Project.all.each do |project|
          dates = []
          dates << project.tasks.minimum(:start_date)
          # quick hack: if no task has a start date, use the earliest end date.
          dates << project.tasks.minimum(:due_date)
          dates << project.supplies.minimum(:due_date)
          project.start_date = dates.compact.min

          dates.clear
          dates << project.tasks.maximum(:due_date)
          dates << project.supplies.maximum(:due_date)
          project.due_date = dates.compact.max

          # fail on validation errors - we need to fix them case by case
          project.save
        end
      end

      dir.down do
        # nothing to do here
      end
    end
  end
end
