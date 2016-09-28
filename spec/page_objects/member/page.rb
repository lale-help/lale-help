module PageObject
  module Member
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/members/{member_id}{?as}'

      include HasItemDetailsTable

      element :headline, '.member-header .title'

      element :block_button, '.button-secondary', text: "Block"
      element :unblock_button, '.button-secondary', text: "Unblock"

    end
  end
end