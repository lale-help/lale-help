class Task::Create < Task::BaseForm
  class Submit < Task::BaseForm::Submit
    def execute
      super.tap do |outcome|
        # TODO: Send task created email
      end
    end
  end
end