class Task::Create < Task::BaseForm
  class Submit < Task::BaseForm::Submit
    def execute
      super.task
    end
  end
end