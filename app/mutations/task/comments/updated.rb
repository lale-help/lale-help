class Task::Comments::Updated < Task::Comments::Base

  def execute
    super unless updated_fields.empty?
  end

  private

  def message_params
    { updated_fields: updated_fields.to_sentence }
  end

  def message
    :updated
  end

  def updated_fields
    @updated_fields ||= task.changes.keys.map { |key| Task.human_attribute_name(key) }
  end

end
