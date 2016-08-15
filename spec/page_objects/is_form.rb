#
# generic form helper module to be included into specific forms
# 
module PageObject
  module IsForm

    def submit_with(attributes)
      fill_form(attributes)
      submit_button.click
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