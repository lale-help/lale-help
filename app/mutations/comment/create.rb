class Comment::Create < Comment::BaseForm
  class Submit < Comment::BaseForm::Submit
    def execute
      super.tap do |outcome|
        if item.is_a? Task
          (item.users.uniq - [ commenter ]).each do |outbound_user|
            next unless outbound_user.email.present?
            TaskMailer.task_comment(item.id, comment.id, outbound_user.id).deliver_later
          end
        end
      end
    end
  end
end
