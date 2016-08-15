require_relative '../component'

module PageObject
  class Component
    class ItemDetailsTable < PageObject::Component

      element :organizer, '.organizer .details'
      element :working_group, '.work-group .details'

    end
  end
end