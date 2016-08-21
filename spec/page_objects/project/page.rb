module PageObject
  module Project
    class Page < PageObject::Page

      include HasItemDetailsTable

      element :name, '.collection-dashboard .header .title'
      element :description, '.collection-dashboard .header .description'

    end
  end
end