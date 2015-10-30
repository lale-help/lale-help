class Task::Role < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  enum role_type: %w[
    task.organizer
    task.volunteer
    task.suggestee
  ]


  def name
    self[:name] || I18n.t!("roles.name.#{self.role_type}")
  end
end
