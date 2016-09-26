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

      section :header, PageObject::Component::TaskableHeader, '.taskable-header'
      delegate :headline, :wait_for_headline, :description, 
        :has_urgency_new?, :wait_for_urgency_new,
        :has_urgency_complete?, :wait_for_urgency_complete,
        to: :header

    end
  end
end