class Task::Create < Task::BaseForm
  class Submit < Task::BaseForm::Submit

    def working_group
      @working_group ||= WorkingGroup.find(working_group_id)
    end
  end
end