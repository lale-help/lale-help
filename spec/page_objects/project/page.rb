module PageObject
  module Project
    class Page < PageObject::Page

      element :name, '.project-dashboard .header .title'
      section :details, PageObject::Component::ItemDetailsTable, '.item-details-table'
      private :details # please don't access from outside as the page structure may change.

      delegate :organizer, :working_group, to: :details

    end
  end
end