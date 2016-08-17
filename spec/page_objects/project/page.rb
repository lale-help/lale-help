module PageObject
  module Project
    class Page < PageObject::Page

      include HasItemDetailsTable

      element :name, '.project-dashboard .header .title'
      element :description, '.project-dashboard .header .description'

    end
  end
end