class WorkingGroup::Create < WorkingGroup::BaseForm

  class Submit < WorkingGroup::BaseForm::Submit

    def validate
      # name must be unique
      condition = ['lower(name) = ? AND circle_id = ?', name.downcase, working_group.circle_id]
      add_error(:name, :not_unique) if WorkingGroup.exists?(condition)
      # organizer is required on create
      add_error(:organizer_id, :empty) if organizer_id.empty?
    end

    def execute
      update_attributes
      # the initial organizer is assigned on create.
      # additional organizers are assigned elsewhere later, with separate UI/code.
      assign_organizer
    end

  end
end
