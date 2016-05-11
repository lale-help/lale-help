class Task::Comments::Updated < Task::Comments::Base

  def execute
    super unless updated_fields.empty?
  end

  private

  def build_message
    I18n.t("tasks.auto_comment.updated", message_params)
  end

  def message_params
    super.merge( 
      updated_fields: updated_fields.to_sentence
    )
  end

  def updated_fields
    @updated_fields ||= task.changes.keys.map { |key| Task.human_attribute_name(key) }
  end

end
