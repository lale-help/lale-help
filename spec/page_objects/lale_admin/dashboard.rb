module PageObject
  module LaleAdmin
    class Dashboard < PageObject::Page

      set_url '/admin{?as}'

      element :headline, 'h2#page_title'
      element :circles_admin_link, 'li#circles a'
    end
  end
end