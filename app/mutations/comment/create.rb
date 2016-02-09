class Comment::Create < Comment::BaseForm
  class Submit < Comment::BaseForm::Submit
    def execute
      super.tap do |outcome|
        (task.users.uniq - [ commenter ]).each do |outboud_user|
          if task.is_a? Task
            TaskMailer.task_comment(task, comment, outboud_user).deliver_now
          else
            # SupplyMailer.task
          end
        end


      end
    end
  end
end
