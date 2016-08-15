module PageObject
  module Task
    class Form < PageObject::Page

      set_url '/circles/{circle_id}/tasks/new?as={as}'

      element :title, 'main.form h2'

      include PageObject::IsForm

      private

      def next_page_object
        Page.new
      end
        
      def fill_form(attributes)
        fill_in "Name of the Task", with: attributes[:name]
        fill_in "Description of the Task", with: attributes[:description]
        fill_in "Place of task", with: attributes[:location]
        fill_date('#task_due_date_string', attributes[:due_date])
      end

      def fill_date(selector, date)
        formatted = date.strftime(I18n.t('circle.tasks.form.date_format'))
        find(selector).set(formatted)
      end

      def submit_button
        find(".submit-row input[type=submit]")
      end

    end
  end
end