module PageObject
  module Supply
    class Page < PageObject::Page

      element :headline, '.task-header .title'
      element :name, '.task-header .title'
      element :description, '.task-header .description'

      section :details, PageObject::Component::ItemDetailsTable, '.item-details-table'

      # FIXME DRY up
      delegate :location, to: :details

      # FIXME DRY up
      def due_date
        Date.parse(details.due_date.text)
      end

    end
  end
end