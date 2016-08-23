module PageObject
  module Circle
    class Member < PageObject::Page

      set_url '/circles/{circle_id}/members/{member_id}{?as}'

      include HasItemDetailsTable

      element :headline, '.member-header .title'

    end
  end
end