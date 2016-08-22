module PageObject
  class Component
    class EditMenu < PageObject::Component

      # the main button
      element :edit_button, '.button-super'

      # all available actions
      # keep me sorted alphabetically
      element :complete, '.menu a', text: /^Complete/
      element :delete, '.menu a', text: /^Delete/
      element :edit, '.menu a', text: /^Edit/
      element :reopen, '.menu a', text: /^Reopen/

      def open
        edit_button.click
      end
    end
  end
end