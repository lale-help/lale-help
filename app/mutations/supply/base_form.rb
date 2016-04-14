class Supply::BaseForm < ::Form
  attribute :supply, :model, primary: true, new_records: true, default: proc { Supply.new circle: circle, working_group: available_working_groups.first }
  attribute :user, :model

  attribute :name,             :string

  attribute :due_date,         :date,   default: proc{ Date.today + 1.week }
  attribute :description,      :string

  attribute :location, :string, default: proc{ (supply.location || circle.address.location).try :address }
  attribute :organizer_id,     :integer, default: proc { supply.organizer.try(:id) || user.id }

  attribute :ability, :model
  attribute :circle, :model

  include TaskableForm

  class Submit < ::Form::Submit

    def project
      project_id.present? ? Project.find(project_id) : nil
    end

    def validate
      add_error(:name, :too_short)                   if name.length < 5
      add_error(:description, :too_short)            if description.length < 5
      add_error(:due_date, :empty)                   if due_date.blank?
      add_error(:location, :empty)                   if location.blank?
    end

    def execute
      supply.tap do |s|
        s.name          = name
        s.due_date      = due_date
        s.description   = description
        s.working_group = working_group
        s.location      = Location.location_from(location)
        s.project       = project
        s.save

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
    end
  end
end