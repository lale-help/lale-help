class Task::Update < Task::BaseForm
  class Submit < Task::BaseForm::Submit
    def execute
      changes = fields_that_changed
      super.tap do |outcome|
        (task.users.uniq - [ user ]).each do |outbound_user|
          next unless outbound_user.email.present?
          TaskMailer.task_change(task, outbound_user, changes).deliver_now
        end
      end
    end

    def fields_that_changed
      [].tap do |array|
        fields_to_track.each do |input, field|
          field_to_check = field.is_a?(Symbol) ? task.send(field) : field.call(task)
          if self.inputs[input].to_s != field_to_check.to_s
            array << Task.human_attribute_name(input)
          end
        end
      end
    end

    def fields_to_track
      {
        name: :name,
        description: :description,
        duration: ->(t) { Task.durations[t.duration] rescue nil },
        scheduling_type: :scheduling_type,
        due_time: :due_time,
        start_time: :start_time,
        volunteer_count_required: :volunteer_count_required,
        project_id: :project_id,
        working_group_id: :working_group_id,
        organizer_id: ->(t) { t.roles.send('task.organizer').first.try(:user_id) },
        primary_location: ->(t) { t.primary_location.try(:address) },
        due_date_string: ->(t) { t.due_date.strftime(I18n.t('circle.tasks.form.date_format')) rescue nil },
        start_date_string: :start_date
      }
    end
  end
end
