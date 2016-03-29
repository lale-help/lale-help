class WorkingGroup::Create < WorkingGroup::BaseForm
  class Submit < WorkingGroup::BaseForm::Submit
    def validate
      if WorkingGroup.where('lower(name) = ? AND circle_id = ?', name.downcase, working_group.circle_id).count > 0
        add_error(:name, :not_unique)
      end
    end
  end
end
