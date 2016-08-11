module PageObject
  class SupplyForm < PageObject::Base

    def initialize(options)
      @action = options[:action]
    end

    def submit_with(attributes)
      fill_form(attributes)
      submit_button.click
      SupplyPage.new # on success, return the next page object
    end

    def invalid?
      find('p', text: 'Please correct the errors below.')
    end

    def has_validation_error?(string)
      find('span.error_description', text: string)
    end

    private

    def fill_form(attributes)
      fill_in "Name of supply",  with: attributes[:name]
      fill_in "Description",     with: attributes[:description]
      fill_in "Due Date",        with: attributes[:due_date]
      fill_in "Location",        with: attributes[:location]
    end

    def submit_button
      button_label = "#{@action.to_s.capitalize} Supply"
      find("input[type=submit][value='#{button_label}']")
    end

  end
end