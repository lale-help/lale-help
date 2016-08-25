module PageObject
  class Component
    class TaskableHeader < PageObject::Component

      element :headline, '.title'
      element :description, '.description'

      def completed?
        find('.taskable-urgency-complete')
      end

      def new?
        find('.taskable-urgency-new')
      end

    end
  end
end