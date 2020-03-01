module PageObject
  module Supply
    class Form < PageObject::Page

      #
      # This URI template works for edit and new form urls:
      # for new:  load(circle_id: 42, action: 'new', as: user_id)
      # for edit: load(circle_id: 42, action: 'edit', supply_id: 43, as: user_id)
      #
      set_url '/circles/{circle_id}/supplies{/supply_id}{/action}{?as}'

      element :title, 'main.form h2'

      include PageObject::IsForm

      private

      def next_page_object
        Page.new
      end

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