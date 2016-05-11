class Task::Comments::Base < Mutations::Command
  required do
    model :task
    model :user
    string :message
  end

  def execute
    attrs = { item: task, commenter: Task::Comments::Base.commenter, body: build_message }
    Comment.create(attrs)
  end

  private

  def message_params
    {
      date: I18n.l(Date.today, format: :long, locale: locale),
      user: user.name
    }
  end

  def build_message
    I18n.t("tasks.auto_comment.#{message}", message_params, locale: locale)
  end

  def locale
    task.circle.language
  end

  def self.commenter
    @commenter ||= User::Identity.find_or_create_by(email: 'lale-bot@lale.help') do |identity|
      identity.password = SecureRandom.uuid
      identity.user = User.new(first_name: 'Lale', last_name: 'Bot', status: :active)
    end.user
  end

end
