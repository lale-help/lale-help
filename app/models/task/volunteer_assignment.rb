class Task::VolunteerAssignment < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :task

  validates :volunteer, uniqueness: { scope: :task_id }
end
