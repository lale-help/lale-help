class Task::LocationAssignment < ActiveRecord::Base
  belongs_to :location
  belongs_to :task
end
