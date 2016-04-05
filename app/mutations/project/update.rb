class Project::Update < Project::BaseForm
  class Submit < Project::BaseForm::Submit
    def execute
      super
    end
  end
end