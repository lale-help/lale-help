class Task::Update < Task::BaseForm
  class Submit < Task::BaseForm::Submit
    def execute
      super.tap do |outcome|
        (task.users.uniq - [ user ]).each do |outbound_user|
          next unless outbound_user.email.present?
          TaskMailer.task_change(task, outbound_user).deliver_now
        end
      end
    end
  end
end