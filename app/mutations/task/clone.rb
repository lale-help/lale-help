class Task::Clone < Mutations::Command
  required do
    model :user
    model :task
  end

  # TODO validate & handle error  
  def execute
    cloned_task = Task.new(new_task_attributes)
    cloned_task.save!
    cloned_task
  end

  private

  # TODO: what about task roles?
  def new_task_attributes
    attrs = task.attributes.reject do |key, value|
      %w(id created_at updated_at completed_at).include?(key) || value.nil?
    end
    attrs['name'] = new_task_name(attrs['name'])
    attrs
  end

  def new_task_name(old_name)
    regexp    = Regexp.new(I18n.t('circle.projects.clone.new_task_name_regexp'))
    matches   = regexp.match(old_name).to_a
    base_name = old_name.gsub(regexp, '')
    
    if matches.empty?
      # task hasn't been cloned yet. return "Some task name copy"
      I18n.t('circle.projects.clone.new_task_name', base_name: base_name)
    elsif matches[1]
      # task already has a number. return "Some task name copy 2", or 3, 4, 5..
      new_number = matches[1].strip.to_i + 1
      I18n.t('circle.projects.clone.new_task_name', base_name: base_name) + " #{new_number}"
    else
      # last case is that it's a copy but no number is given
      new_number = 2
      I18n.t('circle.projects.clone.new_task_name', base_name: base_name) + " #{new_number}"
    end
  end

end
