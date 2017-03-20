class Supply::BaseForm < ::Form
  attribute :supply, :model, primary: true, new_records: true, default: proc { Supply.new }
  attribute :user, :model

  attribute :name,             :string

  attribute :due_date,         :date, default: proc { Date.today + 1.week }
  attribute :description,      :string

  attribute :location, :string, default: proc { supply.location.try(:address) }, required: false
  attribute :organizer_id,     :integer, default: proc { supply.organizer.try(:id) || user.id }

  attribute :ability, :model
  attribute :circle, :model

  include TaskableForm

  class Submit < ::Form::Submit

    def end_before_project
      project && project.due_date && due_date > project.due_date
    end

    def project
      project_id.present? ? Project.find(project_id) : nil
    end

    def validate
      add_error(:name, :too_short)                   if name.length < 5
      add_error(:description, :too_short)            if description.length < 5
      add_error(:due_date, :empty)                   if due_date.blank?
      add_error(:due_date, :end_before)              if end_before_project
    end

    def execute
      supply.assign_attributes(attributes_for_supply_update)
      supply_changes = supply.changes
      supply.save

      supply.tap do |s|
        s.roles.send('supply.organizer').destroy_all

        organizer = User.find_by(id: organizer_id)
        organizer_ability = Ability.new(organizer)

        if organizer_ability.can?(:read, s)
          s.roles.send('supply.organizer').create user_id: organizer_id
        else
          s.roles.send('supply.organizer').create user_id: user.id
        end

        volunteers_to_remove = s.volunteers.select do |volunteer|
          Ability.new(volunteer).cannot?(:read, s)
        end
        s.roles.where(user: volunteers_to_remove).delete_all if volunteers_to_remove.present?
        s.save
      end

      OpenStruct.new(supply: supply, changes: supply_changes)
    end

    def attributes_for_supply_update
      # quick and dirty way to break up the huge #execute method
      attrs = OpenStruct.new

      attrs.name            = name
      attrs.due_date        = due_date
      attrs.description     = description

      attrs.circle          = circle
      attrs.working_group   = working_group
      attrs.project         = project
      if location.present?
        attrs.location      = Location.location_from(location)
      else
        attrs.location      = nil
      end

      attrs.to_h
    end

  end
end
