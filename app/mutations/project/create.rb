class Project::Create < Project::BaseForm

  def current_working_group
    @working_group ||= WorkingGroup.where(id: @working_group_id).first if @working_group_id
  end

  class Submit < Project::BaseForm::Submit
    def execute
      super
    end
  end
end
