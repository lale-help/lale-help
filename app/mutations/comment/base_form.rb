class Comment::BaseForm < ::Form
  attribute :comment, :model, primary: true, new_records: true
  attribute :commenter, :model, class: User
  attribute :task, :model, class: Taskable

  attribute :body,             :string

  class Submit < ::Form::Submit
    def validate
      add_error(:body, :empty)                   if body.blank?
    end

    def execute
      comment.tap do |c|
        c.body          = body
        c.commenter     = commenter
        c.task          = task
        c.save
      end
    end
  end
end
