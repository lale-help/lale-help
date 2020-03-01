#
# Include this object into page objects to:
#
# - adds a #details method to the object includee page (Supply::Page, for example)
# - delegates all calls to fields that live in the item details table to the details method
# - adds helper methods that make working with item details easier
#
module HasItemDetailsTable

  extend ActiveSupport::Concern

  included do
    section :details, PageObject::Component::ItemDetailsTable, '.item-details-table'
    # to prevent strong coupling, item details should not be accessed from outside the page object
    private :details
    delegate :location, :time_commitment, :working_group, :organizer,
      :project, :has_project?, :circles, :contact, :help_provided,
      :due_date_as_date, :due_date_sentence, :member_since_date,
        to: :details
  end

end