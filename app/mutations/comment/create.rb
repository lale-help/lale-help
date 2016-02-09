class Comment::Create < Comment::BaseForm
  class Submit < Comment::BaseForm::Submit
    def mailer_class
      task.is_a? Task ? TaskMailer : SupplyMailer
    end

    def execute
      super.tap do |outcome|
        (task.users.uniq - [ commenter ]).each do |outboud_user|
          mailer_class.task_comment(task, comment, outboud_user).deliver_now
        end
      end
    end
  end
end
