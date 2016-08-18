module PageObject
  module WorkingGroup
    class Form < PageObject::Page

      include PageObject::IsForm

      set_url '/circles/{circle_id}/working_groups/new{?as}'

      element :name, "#working_group_name"
      element :description, "#working_group_description"
      element :access_type, "#working_group_type"
      element :organizer, "#working_group_organizer_id"
      element :submit_button, ".submit-row input[type=submit]"

      private
      
      def next_page_object
        Circle::WorkingGroups.new
      end

      def fill_form(attributes)
        fill_in 'Name', with: attributes[:name]
        fill_in 'Description', with: attributes[:description]
        working_group.select(attributes[:access_type]) if attributes[:access_type]
        organizer.select(attributes[:organizer_name]) if attributes[:organizer_name]
      end
    end
  end
end