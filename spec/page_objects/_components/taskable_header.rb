module PageObject
  class Component
    class TaskableHeader < PageObject::Component

      element :headline, '.title'
      element :description, '.description'

      # I placed these on the date only to be able to assert them in the spec.
      # the urgency-... css classes need to be on the taskable-header to style it correctly.
      element :urgency_new, '.calendar-leaf[data-urgency=new]'
      element :urgency_on_track, '.calendar-leaf[data-urgency=on_track]'
      element :urgency_complete, '.calendar-leaf[data-urgency=complete]'

    end
  end
end