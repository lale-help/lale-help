module PageObject
  module Circle
    class Form < PageObject::Page

      set_url '/circles/{circle_id}/admin{?as}'

      element :name, '#circle_name'
      element :language, '#circle_language'
      element :description, '#circle_description'
      element :city, '#circle_city'
      element :postal_code, '#circle_postal_code'
      element :country, '#circle_country'

      include PageObject::IsForm

      private

      def next_page_object
        self.class.new
      end

      def fill_form(attributes)
        name.set(attributes[:name]) if attributes[:name]
        language.select(attributes[:language]) if attributes[:language]
        description.set(attributes[:description]) if attributes[:description]
        city.set(attributes[:city]) if attributes[:city]
        postal_code.set(attributes[:postal_code]) if attributes[:postal_code]
        country.select(attributes[:country]) if attributes[:country]
      end

      def submit_button
        find(".submit-row input[type=submit]")
      end

    end
  end
end