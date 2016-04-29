class Task::AutoComment < Mutations::Command
  required do
    model :task
    model :user
    # model :task_copied, required: false
    string :message
  end

  def execute
    I18n.locale = task.circle.language
    Comment.create(task: task,
                   commenter: Task::AutoComment.commenter,
                   body: build_message)
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

  def self.commenter
    @commenter ||= User::Identity.find_by(email: 'lale-bot@lale.help').user
  end

end
