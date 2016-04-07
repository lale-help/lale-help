class Supply::BaseForm < ::Form
  attribute :supply, :model, primary: true, new_records: true
  attribute :user, :model
  attribute :working_group, :model

  attribute :name,             :string
  attribute :working_group_id, :string
  attribute :project_id,       :string, required: false
  attribute :due_date,         :date,   default: proc{ Date.today + 1.week }
  attribute :description,      :string

  attribute :location, :string, default: proc{ (supply.location || supply.circle.address.location).try :address }
  attribute :organizer_id,     :integer, default: proc { supply.organizer.try(:id) || user.id }

  attribute :ability, :model
  attribute :circle, :model

  # FIXME extract to module
  def working_group
    @working_group ||= begin
      new_working_group = circle.working_groups.find_by(id: working_group_id) || supply.working_group
      if ability.can? :create_supply, new_working_group
        new_working_group
      else
        supply.working_group
      end
    end
  end

  # FIXME extract to module
  def available_working_groups
    @available_working_groups ||= begin
      working_groups = circle.working_groups.asc_order.to_a
      working_groups.select! { |wg| ability.can?(:manage, wg) } unless ability.can?(:manage, circle)
      working_groups << supply.working_group unless working_groups.present?
      working_groups
    end
  end

  # FIXME extract to module
  def project_select(form)
    # what a ridiculous method dear Rails boys!
    form.grouped_collection_select(
      :project_id, 
      available_working_groups, 
      :projects, 
      :name, 
      :id, 
      :name, 
      {include_blank: I18n.t('circle.tasks.form.project_blank')}
    )
  end

  # FIXME extract to module
  def available_working_groups_disabled?
    if supply.new_record?
      available_working_groups.size == 1 && ability.cannot?(:manage, available_working_groups.first)
    else
      true
    end
  end

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