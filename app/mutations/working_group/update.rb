class WorkingGroup::Update < WorkingGroup::BaseForm

  class Submit < WorkingGroup::BaseForm::Submit

    def validate
      condition = [
        'lower(name) = ? AND circle_id = ? AND id <> ?', 
        name.downcase, working_group.circle_id, working_group.id
      ]
      add_error(:name, :not_unique) if WorkingGroup.exists?(condition)
    end

    def execute
      update_attributes
    end

  end
end
