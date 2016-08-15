module PageObject
  module Project
    class Page < PageObject::Page

      element :name, '.project-dashboard .header .title'
      section :details, PageObject::Component::ItemDetailsTable, '.item-details-table'
      private :details # please don't access from outside as the page structure may change.

      def project_name
        name.text
      end

      def organizer_name
        details.organizer.text
      end

      def working_group_name
        details.working_group.text
      end

    end
  end
end