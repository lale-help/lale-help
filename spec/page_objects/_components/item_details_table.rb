require_relative '../component'

module PageObject
  class Component
    class ItemDetailsTable < PageObject::Component

      # keep me sorted alphabetically
      element :due_date, '.due-date .details'
      element :location, '.location .details'
      element :organizer, '.organizer .details'
      element :project, '.project .details'
      element :time_commitment, '.duration .details'
      element :working_group, '.work-group .details'

    end
  end
end