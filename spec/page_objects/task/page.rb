module PageObject
  module Task
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/tasks/{task_id}{?as}'

      include HasItemDetailsTable

      element :headline, '.task-header .title'
      element :description, '.task-header .description'
      
      section :edit_menu, PageObject::Component::EditMenu, 'aside'

      element :volunteer_button, '.button-primary', text: "I'll help"
      element :decline_button, '.button-primary', text: "I can't help anymore"

      element :find_helpers_button, '#button-open-find-helpers'
      
      # this could be extracted to a FindHelpersModal component
      section :invite_users_form, '.invite-helpers' do
        element :invite_working_group, 'label[for=invite_working_group]'
        element :invite_circle, 'label[for=invite_circle]'
        element :submit_button, '.button-secondary'
      end
      
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

    end
  end
end