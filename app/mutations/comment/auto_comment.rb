class Comment::AutoComment < Mutations::Command
  required do
    model :item, class: Commentable
    model :user
    string :message, default: nil
  end

  def execute
    with_locale(circle_language) do
      attrs = { item: item, commenter: Comment::AutoComment.commenter, body: build_message }
      Comment.create(attrs)
    end
  end

  def with_locale(locale)
    original_locale = I18n.locale
    I18n.locale = locale
    result = yield
    I18n.locale = original_locale
    result
  end

  def circle_language
    item.circle.language
  end

  private

  def common_message_params
    {
        date: I18n.l(Date.today, format: :long),
        user: user.name
    }
  end

  def message_params
    {}
  end

  def build_message
    type_of = item.class.name.pluralize.downcase
    I18n.t("#{type_of}.auto_comment.#{message}", common_message_params.merge(message_params))
  end

  def self.commenter
    @commenter ||= User::Identity.find_or_create_by!(email: 'lale-bot@lale.help') do |identity|
      identity.password = SecureRandom.uuid
      identity.user = User.new(first_name: 'Lale', last_name: 'Bot')
    end.user
  end

end
