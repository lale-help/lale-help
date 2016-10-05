module PageObject
  module Member
    class Form < PageObject::Page

      set_url '/circles/{circle_id}/members/{id}/edit{?as}'

      element :first_name, '#user_first_name'
      element :last_name, '#user_last_name'

      include PageObject::IsForm

      private

      def next_page_object
        PageObject::Member::Page.new
      end        

      def fill_form(attributes)
        first_name.set(attributes[:first_name]) if attributes[:first_name]
        last_name.set(attributes[:last_name]) if attributes[:last_name]
      end

      def submit_button
        find(".submit-row input[type=submit]")
      end

    end
  end
end