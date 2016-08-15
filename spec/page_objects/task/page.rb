module PageObject
  module Task
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/tasks/{task_id}?as={as}'

      element :headline, '.task-header .title'
      element :description, '.task-header .description'

      section :details, PageObject::Component::ItemDetailsTable, '.item-details-table'

      element :volunteer_button, '.button-primary', text: "I'll help"
      element :decline_button, '.button-primary', text: "I can't help anymore"
      
      element :task_badge, '.users-box .task-badge'
      elements :helper_badges, '.users-box .user-badge'

      # FIXME DRY up
      delegate :location, :time_commitment, :working_group, :organizer, :project, :has_project?,
        to: :details

      # FIXME DRY up
      def due_date
        Date.parse(details.due_date.text)
      end

      def due_date_sentence
        details.due_date.text
      end

      def num_required_volunteers
        ((/\/(\d+)/).match(text))[1].to_i
      end

      # FIXME generalize
      def load_for(task, as:)
        load(circle_id: task.circle.id, task_id: task.id, as: as.id)
      end

      def helper_names
        helper_badges.map { |badge| badge.find('.user-name-shortened').text }
      end

    end
  end
end