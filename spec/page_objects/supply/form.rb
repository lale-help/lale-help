module PageObject
  module Supply
    class Form < PageObject::Page

      include PageObject::IsForm

      def next_page_object
        Page.new
      end
        
      private

      def fill_form(attributes)
        fill_in "Name of supply",  with: attributes[:name]
        fill_in "Description",     with: attributes[:description]
        fill_in "Due Date",        with: attributes[:due_date]
        fill_in "Location",        with: attributes[:location]
      end

      def submit_button
        find(".submit-row input[type=submit]")
      end

    end
  end
end