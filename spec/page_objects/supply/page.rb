module PageObject
  module Supply
    class Page < PageObject::Page

      set_url '/circles/{circle_id}/supplies/{supply_id}?as={as}'

      include HasItemDetailsTable

      element :headline, '.task-header .title'
      element :description, '.task-header .description'

      # FIXME factor out
      element :edit_button, 'aside .button-super'
      element :complete_button, 'aside .menu a', text: /^Complete/
      element :reopen_button, 'aside .menu a', text: /^Reopen/
      element :delete_button, 'aside .menu a', text: /^Delete/

      # FIXME factor out
      def load_for(supply, as:)
        load(circle_id: supply.circle.id, supply_id: supply.id, as: as.id)
      end

      # FIXME factor out
      def completed?
        find('.task.urgency--complete')
      end

      # FIXME factor out
      def new?
        find('.task.urgency--new')
      end

      # FIXME factor out
      def has_flash?(message)
        find('.flash-message', text: message)
      end

    end
  end
end