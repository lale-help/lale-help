class Project::Create < Project::BaseForm
  class Submit < Project::BaseForm::Submit
    def execute
      super

      project.roles.create(role_type: 'admin', user: user)

    end
  end
end