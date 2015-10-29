class Task::VolunteerAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates :user, uniqueness: { scope: :task_id }
end
