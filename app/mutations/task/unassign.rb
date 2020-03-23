class Task::Unassign < Mutations::Command

  required do
    array :users
    model :task
    model :current_user, class: User
  end

  def validate
    add_error(:user, :empty) if users.empty?
    users.each do |user|
      add_error(:user, :no_volunteer) unless volunteer_role.exists?(task: task, user: user)
    end
  end

  def execute
    unassignments = users.map do |user|
      volunteer_role.find_by(task: task, user: user).destroy
    end

    if unassignments.all? { |a| a.destroyed? }
      notify_existing_volunteers
      notify_unassignees
      create_task_comment
    else
      add_error :assignment, :failed
    end

    unassignments
  end

  private

  def notify_existing_volunteers
    existing_volunteers.each do |volunteer|
      changes = { volunteers: [] } # a slight hack; only the key is relevant
      TaskMailer.task_change(task.id, volunteer.id, changes).deliver_later
    end
  end

  def notify_unassignees
    (users - [current_user]).each do |user|
      TaskMailer.task_unassigned(task.id, user.id).deliver_later
    end
  end

  def create_task_comment
    Task::Comments::Unassigned.run!(item: task, unassignees: users, user: current_user)
  end

  def existing_volunteers
    (task.users.uniq - users).select { |u| u.email.present? }
  end

  def volunteer_role
    Task::Role.send('task.volunteer')
  end
end
