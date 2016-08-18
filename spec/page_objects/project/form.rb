module PageObject
  module Project
    class Form < PageObject::Page

      include PageObject::IsForm

      set_url '/circles/{circle_id}/projects/new{?as}'

      element :name, "#project_name"
      element :description, "#project_description"
      element :working_group, "#project_working_group_id"
      element :organizer, "#project_organizer_id"
      element :submit_button, ".submit-row input[type=submit]"

      private
      
      def next_page_object
        Page.new
      end

      def fill_form(attributes)
        fill_in 'Project name', with: attributes[:name]
        fill_in 'Description', with: attributes[:description]
        working_group.select(attributes[:working_group_name]) if attributes[:working_group_name]
        organizer.select(attributes[:organizer_name]) if attributes[:organizer_name]
      end
    end
  end
end