module PageObject
  module Supply
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/supplies/{supply_id}{?as}'

      include HasItemDetailsTable

      section :edit_menu, PageObject::Component::EditMenu, 'aside'

      element :volunteer_button, '.button-primary', text: "I have this Supply"
      element :decline_button, '.button-primary', text: "I don't have this Supply"
      
      section :helpers_box, PageObject::Component::UsersBox, '.users-box'
      delegate :helpers, :has_helper?, to: :helpers_box

      section :header, PageObject::Component::TaskableHeader, '.task-header'
      delegate :headline, :wait_for_headline, :description, :completed?, :new?, 
        :has_urgency_complete?, :has_urgency_new?, to: :header

    end
  end
end