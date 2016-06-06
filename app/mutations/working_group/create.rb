class WorkingGroup::Create < WorkingGroup::BaseForm
  class Submit < WorkingGroup::BaseForm::Submit
    def validate
      condition = ['lower(name) = ? AND circle_id = ?', name.downcase, working_group.circle_id]
      add_error(:name, :not_unique) if WorkingGroup.exists?(condition)
    end
  end
end
