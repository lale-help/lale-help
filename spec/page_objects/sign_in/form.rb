module PageObject
  module SignIn
    class Form < PageObject::Page

      set_url '/'

      element :headline, '#login_form h2'
      element :email, 'input#email'
      element :password, 'input#password'
      element :submit_button, '.button.login'

      include PageObject::IsForm

      private

      def next_page_object
        PageObject::Circle::Dashboard.new
      end

      def fill_form(attributes)
        email.set(attributes[:email])
        password.set(attributes[:password])
      end

    end
  end
end