module PageObject
  class ProjectForm < PageObject::Base

    def initialize(options)
      @type = options[:type]
    end

    def submit_with(attributes)
      fill_form(attributes)
      submit_button.click
      ProjectPage.new # on success, return the next page object
    end

    def invalid?
      find('p', text: 'Please correct the errors below.')
    end

    def has_validation_error?(string)
      find('span.error_description', text: string)
    end

    private

    def fill_form(attributes)
      fill_in "Project name", with: attributes[:name]
      if attributes[:working_group_name]
        find("#project_working_group_id").select(attributes[:working_group_name])
      end
      if attributes[:organizer_name]
        find("#project_organizer_id").select(attributes[:organizer_name])
      end
    end

    def submit_button
      button_label = "#{@type.to_s.capitalize} Project"
      find("input[type=submit][value='#{button_label}']")
    end

  end
end