module PageObject
  class Component
    class ItemDetailsTable < PageObject::Component

      # keep me sorted alphabetically
      element :circles, '.circles .details'
      element :contact, '.contact .details'
      element :due_date, '.due-date .details'
      element :help_provided, '.completed .details'
      element :location, '.location .details'
      element :member_since, '.member-since .details'
      element :organizer, '.organizer .details'
      element :project, '.project .details'
      element :time_commitment, '.duration .details'
      element :working_group, '.work-group .details'

    end
  end
end