class Comment::BaseForm < ::Form
  attribute :comment, :model, primary: true, new_records: true
  attribute :commenter, :model, class: User
  attribute :item, :model, class: Commentable

  attribute :body,             :string

  class Submit < ::Form::Submit
    def validate
      add_error(:body, :empty)                   if body.blank?
    end

    def execute
      comment.tap do |c|
        c.body          = body
        c.commenter     = commenter
        c.item          = item
        c.save
      end
    end
  end
end
