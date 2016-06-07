class Task::Update < Task::BaseForm

  class Submit < Task::BaseForm::Submit

    def execute
      outcome = super
      notify_users
      create_updates_comment
      outcome.task
    end

    private

    def notify_users
      if send_notifications && task_changes.present?
        users_to_notify.each { |user| TaskMailer.task_change(task, user, task_changes).deliver_now }
      end
    end

    def create_updates_comment
      Task::Comments::Updated.run!(task: task, user: user, changes: task_changes)
    end

    def users_to_notify
      (task.users.uniq - [ user ]).select { |u| u.email.present? }
    end

  end
end