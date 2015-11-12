class Supply::Update < Supply::BaseForm
  class Submit < Supply::BaseForm::Submit
    def execute
      super.tap do |outcome|
        # TODO: Send task updated email
      end
    end
  end
end