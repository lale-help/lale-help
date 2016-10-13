module PageObject
  module Task
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/tasks/{task_id}{?as}'

      include HasItemDetailsTable

      section :edit_menu, PageObject::Component::EditMenu, 'aside'

      section :helpers_box, PageObject::Component::UsersBox, '.users-box'
      delegate :helpers, :has_helper?, to: :helpers_box

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

      section :header, PageObject::Component::TaskableHeader, '.taskable-header'
      delegate :headline, :wait_for_headline, :description, 
        :has_urgency_new?, :wait_for_urgency_new,
        :has_urgency_complete?, :wait_for_urgency_complete,
        to: :header

      def num_required_volunteers
        ((/\/(\d+)/).match(helpers_box.text))[1].to_i
      end

    end
  end
end