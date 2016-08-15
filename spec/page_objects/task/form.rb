module PageObject
  module Task
    class Form < PageObject::Page

      set_url '/circles/{circle_id}/tasks/new?as={as}'

      element :title, 'main.form h2'

      include PageObject::IsForm

      def next_page_object
        Page.new
      end
        
      private

      def fill_form(attributes)
        fill_in "Name of the Task",  with: attributes[:name]
        fill_in "Description of the Task", with: attributes[:description]
        # fill_in "Due Date",        with: attributes[:due_date]
        # fill_in "Location",        with: attributes[:location]
      end

      def submit_button
        find(".submit-row input[type=submit]")
      end

    end
  end
end