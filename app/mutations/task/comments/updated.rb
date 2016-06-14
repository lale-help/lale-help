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
    klass = task.is_a?(Supply) ? Supply : Task
    { changed_fields: changed_fields.map { |key| klass.human_attribute_name(key) }.to_sentence }
  end

  def message
    :updated
  end

  def changed_fields
    changes.keys
  end

end
