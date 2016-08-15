module PageObject
  module Supply
    class Page < PageObject::Page

      element :h1_title, '.task-header .title'
      element :name, '.task-header .title'
      element :description, '.task-header .description'
      element :location, '.item-details-table .location .details'
      element :_due_date, '.item-details-table .due-date .details'

      # FIXME DRY up with task page
      def wait_for_page_title
        wait_for_h1_title
      end

      # FIXME DRY up with task page
      def page_title
        h1_title.text
      end

      def due_date
        Date.parse(_due_date.text)
      end

    end
  end
end