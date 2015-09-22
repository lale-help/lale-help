class TaskVolunteer < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :task
end
