class Task::Comments::BaseComment < Mutations::Command
  required do
    model :task
    model :user
    string :message
  end

  def execute
    I18n.locale = task.circle.language
    Comment.create(task: task,
                   commenter: Task::Comments::BaseComment.commenter,
                   body: build_message)
  end

  private

  def message_params
    {}.tap do |hash|
      hash[:date] =  I18n.l(Date.today, format: :long)
      hash[:user] = user.name
    end
  end

  def build_message
    I18n.t("tasks.auto_comment.#{message}", message_params)
  end

  def self.commenter
    @commenter ||= User::Identity.find_or_create_by(email: 'lale-bot@lale.help') do |identity|
      identity.password = SecureRandom.uuid
      identity.user = User.new(first_name: 'Lale', last_name: 'Bot', status: :active)
    end.user
  end

end
