class Task::Update < Task::Form
  class Submit < Task::Form::Submit
    def execute
      super.tap do |outcome|
        # TODO: Send task updated email
      end
    end
  end
end