module PageObject
  class Component
    class CollectionDashboardHeader < PageObject::Component

      element :headline, '.title'
      element :description, '.description'

    end
  end
end