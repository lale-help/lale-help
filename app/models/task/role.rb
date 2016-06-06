class Task::Role < ActiveRecord::Base
  belongs_to :task, touch: true
  belongs_to :user

  enum role_type: %w[
    task.organizer
    task.volunteer
    task.suggestee
  ]

  scope :with_role, ->(role_name) { where(role_type: role_types[role_name]) }

  def name
    self[:name] || I18n.t!("roles.name.#{self.role_type}")
  end

  # override default comparison method, treating roles as value objects.
  def ==(other_task)
    %i(role_type user_id task_id).all? { |attribute| self.send(attribute) == other_task.send(attribute) }
  end
end
