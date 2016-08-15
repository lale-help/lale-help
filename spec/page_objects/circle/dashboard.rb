module PageObject
  module Circle
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}?as={as}'

      # could be extracted to component
      element :add_button, '.button-super', text: /Add/
      element :supply_button, '.menu a', text: /Supply/
      element :task_button, '.menu a', text: /Task/
      
      section :tab_nav, '.tab-nav' do
        element :supplies, 'a', text: /Supplies/
      end

      element :page_title_element, '.circle-dashboard .header .title'
      elements :tasks, ".open_tasks .task"
      elements :supplies, ".open_supplies .task"

      def page_title
        page_title_element.text
      end

    end
  end
end