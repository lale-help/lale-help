class Task::Comments::Updated < Task::Comments::Base

  required do
    # I don't use hash here since I'd have to define all possible keys
    model :changes, class: 'HashWithIndifferentAccess'
  end

  def execute
    super unless changed_fields.empty?
  end

  private

  def message_params
    { changed_fields: changed_fields.to_sentence }
  end

  def message
    :updated
  end

  def changed_fields
    @changed_fields ||= changes.keys.map { |key| Task.human_attribute_name(key) }
  end

end
