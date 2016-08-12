module PageObject
  class ProjectForm

    include PageObject::Form

    def next_page_object
      ProjectPage.new
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
      find(".submit-row input[type=submit]")
    end

  end
end