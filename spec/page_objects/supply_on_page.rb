# FIXME split to SupplyForm and SupplyPage
module PageObject
  class SupplyOnPage < PageObject::Base

    def initialize(attrs = {})
      self.attributes = attrs
    end

    def attributes=(attrs)
      attrs.each { |key, value| send("#{key}=", value) }
    end

    attr_accessor :name, :description, :due_date, :location

    def create
      add_button.click
      supply_button.click
      fill_form
      submit_button.click
    end

    def created?
      find('.task-header .title', text: name)
    end

    def invalid?
      find('p', text: 'Please correct the errors below.')
    end

    def has_validation_error?(string)
      find('span.error_description', text: string)
    end

    private

    def add_button
      find('.button-super', text: /Add/)
    end

    def supply_button
      find('.menu a', text: /Supply/)
    end

    def submit_button
      find('input[type=submit][value="Create Supply"]')
    end

    def fill_form
      fill_in "Name of supply",  with: name
      fill_in "Description",     with: description
      fill_in "Due Date",        with: due_date
      fill_in "Location",        with: location
    end
  end
end