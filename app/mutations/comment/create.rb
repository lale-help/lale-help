class Comment::Create < Comment::BaseForm
  class Submit < Comment::BaseForm::Submit
    def execute
      super.tap do |outcome|
        #TODO: send email
      end
    end
  end
end
