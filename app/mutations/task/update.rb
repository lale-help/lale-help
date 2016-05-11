class Task::Update < Task::BaseForm

  class Submit < Task::BaseForm::Submit

    def execute
      outcome = super
      notify_users(outcome.changes)
      create_updates_comment(outcome.changes)
      outcome.task
    end

    private

    def notify_users(changes)
      users_to_notify.each { |user| TaskMailer.task_change(task, user, changes).deliver_now }
    end

    def create_updates_comment(changes)
      Task::Comments::Updated.run!(task: task, user: user, changes: changes)
    end

    def users_to_notify
      (task.users.uniq - [ user ]).select { |u| u.email.present? }
    end

  end
end