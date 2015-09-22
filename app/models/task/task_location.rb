class TaskLocation < ActiveRecord::Base
  belongs_to :location
  belongs_to :task
end
