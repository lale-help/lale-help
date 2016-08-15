module PageObject
  module Supply
    class Page < PageObject::Page

      element :name, '.task-header .title'
      element :description, '.task-header .description'
      element :location, '.item-details-table .location .details'
      element :_due_date, '.item-details-table .due-date .details'

      def due_date
        Date.parse(_due_date.text)
      end

    end
  end
end