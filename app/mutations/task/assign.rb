class Task::Assign < Mutations::Command
  
  required do
    array :users
    model :task
    model :current_user, class: User
  end

  def validate
    add_error(:users, :empty) if users.empty?
    users.each do |user|
      add_error(:users, :already_volunteered) if volunteer_role.exists?(task: task, user: user)
    end
  end

  def execute
    assignments = users.map do |user|
      volunteer_role.create(task: task, user: user)
    end

    if assignments.all? { |a| a.persisted? }
      notify_existing_volunteers
      notify_new_assignees
      create_task_comment
    else
      add_error :assignment, :failed
    end

    assignments
  end

  private

  def notify_existing_volunteers
    existing_volunteers.each do |volunteer|
      changes = { volunteers: [] } # a slight hack; only the key is relevant
      TaskMailer.task_change(task, volunteer, changes).deliver_now
    end
  end

  def notify_new_assignees
    (users - [current_user]).each do |user|
      TaskMailer.task_assigned(task, user).deliver_now
    end
  end

  def create_task_comment
    Task::Comments::Assigned.run!(item: task, assignees: users, user: current_user)
  end

  def existing_volunteers
    (task.users.uniq - users).select { |u| u.email.present? }
  end

  def volunteer_role
    Task::Role.send('task.volunteer')
  end
end
