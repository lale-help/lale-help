module PageObject
  module Task
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/tasks/{task_id}?as={as}'

      include HasItemDetailsTable

      element :headline, '.task-header .title'
      element :description, '.task-header .description'

      element :volunteer_button, '.button-primary', text: "I'll help"
      element :decline_button, '.button-primary', text: "I can't help anymore"
      
      element :edit_button, '.task-edit-menu .button-super'
      element :complete_button, '.task-edit-menu .menu a', text: 'Complete Task'
      element :reopen_button, '.task-edit-menu .menu a', text: 'Reopen Task'

      element :task_badge, '.users-box .task-badge'
      elements :helper_badges, '.users-box .user-badge'

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

      def completed?
        find('.task.urgency--complete')
      end

      def new?
        find('.task.urgency--new')
      end

    end
  end
end