module PageObject
  module Task
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/tasks/{task_id}?as={as}'

      include HasItemDetailsTable

      element :headline, '.task-header .title'
      element :description, '.task-header .description'

      element :volunteer_button, '.button-primary', text: "I'll help"
      element :decline_button, '.button-primary', text: "I can't help anymore"
      
      # FIXME factor out
      element :edit_button, 'aside .button-super'
      element :complete_button, 'aside .menu a', text: /^Complete/
      element :reopen_button, 'aside .menu a', text: /^Reopen/
      element :delete_button, 'aside .menu a', text: /^Delete/

      element :task_badge, '.users-box .task-badge'
      elements :helper_badges, '.users-box .user-badge'

      def num_required_volunteers
        ((/\/(\d+)/).match(text))[1].to_i
      end

      # FIXME factor out
      def load_for(task, as:)
        load(circle_id: task.circle.id, task_id: task.id, as: as.id)
      end

      # FIXME factor out
      def helper_names
        helper_badges.map { |badge| badge.find('.user-name-shortened').text }
      end

      # FIXME factor out
      def completed?
        find('.task.urgency--complete')
      end

      # FIXME factor out
      def new?
        find('.task.urgency--new')
      end
      
      # FIXME factor out
      def has_flash?(message)
        find('.flash-message', text: message)
      end


    end
  end
end