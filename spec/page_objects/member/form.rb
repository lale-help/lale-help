module PageObject
  module Member
    class Form < PageObject::Page

      set_url '/circles/{circle_id}/members/{id}/edit{?as}'

      element :first_name, '#user_first_name'
      element :last_name, '#user_last_name'
      element :profile_image, '#user_profile_image'
      element :remove_profile_image, '#user_remove_profile_image'

      include PageObject::IsForm

      private

      def next_page_object
        PageObject::Member::Page.new
      end        

      def fill_form(attributes)
        first_name.set(attributes[:first_name]) if attributes[:first_name]
        last_name.set(attributes[:last_name]) if attributes[:last_name]
        profile_image.set(attributes[:profile_image]) if attributes[:profile_image]
        if attributes[:remove_profile_image]
          # the form is long, and we need to get at the checkbox after the fold
          page.current_window.resize_to(1024, 1024)
          remove_profile_image.set(attributes[:remove_profile_image])
        end
      end

      def submit_button
        find(".submit-row input[type=submit]")
      end

    end
  end
end