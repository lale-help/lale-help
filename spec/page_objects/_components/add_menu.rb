module PageObject
  class Component
    class AddMenu < PageObject::Component

      # the main button
      element :add_button, '#sidebar .button-super', text: /Add/

      # keep me sorted alphabetically
      element :project, '.menu a', text: /Project/
      element :supply, '.menu a', text: /Supply/
      element :task, '.menu a', text: /Task/

      def open
        add_button.click
      end
    end
  end
end