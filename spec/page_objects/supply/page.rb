module PageObject
  module Supply
    class Page < PageObject::Page

      include HasItemDetailsTable

      element :headline, '.task-header .title'
      element :description, '.task-header .description'

    end
  end
end