require_relative '../component'

module PageObject
  class Component
    class ItemDetailsTable < PageObject::Component

      element :organizer, '.organizer .details'
      element :working_group, '.work-group .details'
      element :location, '.location .details'
      element :due_date, '.due-date .details'

    end
  end
end