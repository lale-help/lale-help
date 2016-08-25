module PageObject
  module Supply
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/supplies/{supply_id}{?as}'

      include HasItemDetailsTable

      element :headline, '.task-header .title'
      element :description, '.task-header .description'

      section :edit_menu, PageObject::Component::EditMenu, 'aside'

      element :volunteer_button, '.button-primary', text: "I have this Supply"
      element :decline_button, '.button-primary', text: "I don't have this Supply"
      
      section :helpers_box, PageObject::Component::UsersBox, '.users-box'
      delegate :helpers, :has_helper?, to: :helpers_box

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