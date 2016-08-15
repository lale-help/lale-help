module PageObject
  module Project
    class Form < PageObject::Page

      include PageObject::Form

      set_url '/circles/{circle_id}/projects/new?as={as_id}'

      element :name, "#project_name"
      element :working_group, "#project_working_group_id"
      element :organizer, "#project_organizer_id"
      element :submit_button, ".submit-row input[type=submit]"

      def next_page_object
        PageObject::Project::Page.new
      end

      def fill_form(attributes)
        name.set(attributes[:name])
        if attributes[:working_group_name]
          working_group.select(attributes[:working_group_name])
        end
        if attributes[:organizer_name]
          organizer.select(attributes[:organizer_name])
        end
      end
    end
  end
end