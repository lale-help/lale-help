#
# generic form helper module to be included into specific forms
#
module PageObject
  module IsForm

    def submit_with(attributes, show: false)
      fill_form(attributes)
      # useful to check the form is filled out as expected
      save_and_open_screenshot if show
      # "submit_button.click" fails when the button is not inside the viewport.
      submit_button.trigger(:click)
      next_page_object # on success, return the next page object
    end

    def invalid?
      find('p', text: 'Please correct the errors below.')
    end

    def has_validation_error?(string)
      find('span.error_description', text: string)
    end

  end
end