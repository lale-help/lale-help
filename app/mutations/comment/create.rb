class Comment::Create < Comment::BaseForm
  class Submit < Comment::BaseForm::Submit
    def execute
      super.tap do |outcome|
        if task.is_a? Task
          (task.users.uniq - [ commenter ]).each do |outboud_user|
            next unless outboud_user.email.present?
            TaskMailer.task_comment(task, comment, outboud_user).deliver_now
          end
        end
      end
    end
  end
end
