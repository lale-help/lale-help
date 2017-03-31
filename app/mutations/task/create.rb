class Task::Create < Task::BaseForm

  def working_group_disabled?
    super || ! @working_group_id.nil?
  end

  class Submit < Task::BaseForm::Submit
    def execute
      super.task
    end
  end
end
