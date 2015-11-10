class Task::Create < Task::Form
  class Submit < Task::Form::Submit
    def execute
      super.tap do |outcome|
        # TODO: Send task created email
      end
    end
  end
end