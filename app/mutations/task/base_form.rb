class Task::BaseForm < ::Form
  attribute :task, :model, primary: true, new_records: true
  attribute :user, :model
  attribute :working_group, :model

  attribute :name,             :string
  attribute :working_group_id, :string
  attribute :due_date,         :date,   default: proc{ Date.today + 1.week }
  attribute :description,      :string

  attribute :primary_location, :string, default: proc{ (task.primary_location || task.circle.location).try :address }
  attribute :organizer_id,     :integer, default: proc { task.organizer.try(:id) || user.id }

  attribute :duration,      :integer

  attribute :scheduled_time_type,  :string, required: false
  attribute :scheduled_time_start, :string, required: false
  attribute :scheduled_time_end,   :string, required: false

  attribute :volunteer_count_required, :integer, default: proc { 1 }

  def duration_unit_options
    [
      [ "Hours",   'hour' ],
      [ "Minutes", 'minute' ]
    ]
  end

  def scheduled_time_type_options
    [
      ["On Day",      'on_date' ],
      ["At",          'at'      ],
      ["In Between",  'between' ]
    ]
  end

  def scheduled_time_options
    ("0".."23").map do |hour|
      %w(00 15 30 45).map do |min|
        "#{hour}:#{min}"
      end
    end.flatten
  end

  def duration_options
    Task.durations.map do |key, val|
      [I18n.t("activerecord.attributes.task.duration-text.#{key}"), val]
    end
  end

  class Submit < ::Form::Submit
    def validate
      add_error(:name, :too_short)                   if name.length < 5
      add_error(:description, :too_short)            if description.length < 5
      add_error(:due_date, :empty)                   if due_date.blank?
      add_error(:primary_location, :empty)           if primary_location.blank?
      add_error(:volunteer_count_required, :too_low) if volunteer_count_required < 1
    end

    def execute
      task.tap do |t|
        t.name          = name
        t.due_date      = due_date
        t.description   = description
        t.working_group = working_group

        t.duration      = duration

        t.scheduled_time_type   = scheduled_time_type
        t.scheduled_time_start  = scheduled_time_start
        t.scheduled_time_end    = scheduled_time_end

        t.volunteer_count_required = volunteer_count_required

        t.save

        t.roles.send('task.organizer').destroy_all
        t.roles.send('task.organizer').create user_id: organizer_id

        t.location_assignments.destroy_all
        t.location_assignments.create primary: true, location: Location.location_from(primary_location)

        t.save
      end
    end
  end
end