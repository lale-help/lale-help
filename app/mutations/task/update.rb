class Task::Update < Task::BaseForm

  class Submit < Task::BaseForm::Submit

    def execute
      outcome = super
      notify_users
      create_task_comment
      outcome.task
    end

    private

    def notify_users
      if send_notifications && task_changes.present?
        users_to_notify.each { |user| TaskMailer.delay.task_change(task.id, user.id, task_changes) }
      end
    end

    def create_task_comment
      Task::Comments::Updated.run!(item: task, user: user, changes: task_changes)
    end

    def users_to_notify
      (task.users.uniq - [ user ]).select { |u| u.email.present? }
    end

  end
end
