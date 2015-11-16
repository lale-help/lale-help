class Supply::Create < Supply::BaseForm
  class Submit < Supply::BaseForm::Submit
    def execute
      super.tap do |outcome|
        # TODO: Send task created email
      end
    end
  end
end