class Task::Update < Task::BaseForm
  class Submit < Task::BaseForm::Submit
    def execute
      super.tap do |outcome|
        # TODO: Send task updated email
      end
    end
  end
end