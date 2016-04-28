class Task::AutoComment < Mutations::Command
  required do
    model :task
    model :user
    # model :task_copied, required: false
    string :message
  end

  def execute
    I18n.locale = task.circle.language

    # TODO create bot user
    commenter = User.find_by(first_name: 'Lale', last_name: 'Bot')

    comment = Comment.create(task: task,
                             commenter: commenter,
                             body: build_message)

    comment
  end

  private

  def build_message
    params = {}.tap do |hash|
      hash[:date] =  I18n.l(Date.today, format: :long)
      hash[:user] = user.name
      case message
        when 'copied'
          hash[:original_task] = task_copied.name
        when 'data_changed'
          hash[:fields_changed] = '...'
      end
    end
    I18n.t("tasks.auto_comment.#{message}", params)
  end

end
