module PageObject
  module Task
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/tasks/{task_id}?as={as_id}'

      element :h1_title, '.task-header .title'
      element :description, '.task-header .description'
      element :volunteer_button, '.button-primary', text: "I'll help"
      element :decline_button, '.button-primary', text: "I can't help anymore"
      elements :helper_badges, '.users-box .user-badge'

      def wait_for_page_title
        wait_for_h1_title
      end

      def page_title
        h1_title.text
      end

      def load_for(task, as:)
        load(circle_id: task.circle.id, task_id: task.id, as_id: as.id)
      end

      def helper_names
        helper_badges.map { |badge| badge.find('.user-name-shortened').text }
      end

    end
  end
end