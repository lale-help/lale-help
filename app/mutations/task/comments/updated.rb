class Task::Comments::Updated < Comment::AutoComment

  required do
    # I don't use hash here since I'd have to define all possible keys
    model :changes, class: 'HashWithIndifferentAccess'
  end

  def execute
    super unless changed_fields.empty?
  end

  private

  def message_params
    klass = item.class
    { changed_fields: changed_fields.map { |key| klass.human_attribute_name(key) }.to_sentence }
  end

  def message
    :updated
  end

  def changed_fields
    changes.keys
  end

end
