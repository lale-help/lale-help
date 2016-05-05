class Task::BaseForm < ::Form
  attribute :task, :model, primary: true, new_records: true, default: proc{ Task.new }
  attribute :user, :model

  attribute :name,             :string
  attribute :description,      :string

  attribute :primary_location, :string, default: proc{ (task.primary_location || circle.address.location).try :address }
  attribute :organizer_id,     :integer, default: proc { task.organizer.try(:id) || user.id }

  attribute :duration,      :integer

  attribute :scheduling_type,   :string

  # getters for form display
  attribute :due_date_string,   :string, required: false, default: proc { stringify_date(self.due_date || Date.today + 1.week) }
  attribute :start_date_string, :string, required: false, default: proc { stringify_date(self.start_date) }
  # getters/setters for saving on update
  attribute :due_date,          :date, format: I18n.t('circle.tasks.form.date_format')
  attribute :start_date,        :date, required: false
  # times
  attribute :due_time,          :string, required: false, default: proc { nil }
  attribute :start_time,        :string, required: false, default: proc { nil }

  attribute :volunteer_count_required, :integer, default: proc { 1 }

  attribute :ability, :model
  attribute :circle, :model

  attribute :original_task_id,  :string, required: false, default: proc { nil }

  include TaskableForm




  def start_date_string=(string)
    self.start_date = parse_date(string) if string.present?
  end

  def due_date_string=(string)
    self.due_date = parse_date(string)
  end

  def parse_date(string)
    string.present? && Date.strptime(string, I18n.t('circle.tasks.form.date_format'))
  end

  def stringify_date(date)
    date && date.strftime(I18n.t('circle.tasks.form.date_format'))
  end
  private :parse_date, :stringify_date

  def scheduling_type_options
    I18n.t("activerecord.attributes.task.scheduling_type_options").invert.to_a
  end

  # the duration is informational only, not relevant for the start/due dates.
  def duration_options
    Task.durations.map do |key, val|
      [I18n.t("activerecord.attributes.task.duration-text.#{key}"), val]
    end
  end

  class Submit < ::Form::Submit

    TIME_REGEX = /^[0-2]?[0-9]:[0-5][0-9]$/

    def validate
      add_error(:name, :too_short)                   if name.length < 5
      add_error(:description, :too_short)            if description.length < 5
      add_error(:due_date, :empty)                   if due_date.blank?
      add_error(:primary_location, :empty)           if primary_location.blank?
      add_error(:volunteer_count_required, :too_low) if volunteer_count_required < 1
      add_error(:start_time, :format)                if start_time.present? && start_time !~ TIME_REGEX
      add_error(:due_time, :format)                  if due_time.present? && due_time !~ TIME_REGEX
      add_error(:start_date, :empty)                 if scheduling_type == 'between' && start_date.blank?
    end

    def execute
      task.tap do |t|
        t.name          = name
        t.description   = description

        t.circle        = circle
        t.working_group = working_group
        t.project       = project

        t.duration      = duration

        t.scheduling_type = scheduling_type
        t.start_date      = (scheduling_type == 'between') ? start_date : nil
        t.start_time      = (scheduling_type == 'between' && start_time.present?) ? start_time : nil

        t.due_date        = due_date
        t.due_time        = due_time.present? ? due_time : nil

        t.volunteer_count_required = volunteer_count_required

        t.save

        t.roles.send('task.organizer').destroy_all

        organizer = User.find_by(id: organizer_id)
        organizer_ability = Ability.new(organizer)

        if organizer_ability.can?(:read, t)
          t.roles.send('task.organizer').create user_id: organizer_id
        else
          t.roles.send('task.organizer').create user_id: user.id
        end

        volunteers_to_remove = t.volunteers.select do |volunteer|
          Ability.new(volunteer).cannot? :read, t
        end
        t.roles.where(user: volunteers_to_remove).delete_all if volunteers_to_remove.present?

        t.location_assignments.destroy_all
        t.location_assignments.create primary: true, location: Location.location_from(primary_location)

        t.save

        if original_task_id.present?
          Task::Comments::ClonedTaskComment.run(task: t, message: 'copied', user: user, task_cloned: Task.find(original_task_id))
        end
      end
    end
  end
end
