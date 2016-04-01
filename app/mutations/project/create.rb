class Project::Create < Project::BaseForm
  class Submit < Project::BaseForm::Submit
    def execute
      super
    end
  end
end