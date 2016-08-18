module PageObject
  module Circle
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}{?as}'

      # could be extracted to component
      element :add_button, '.button-super', text: /Add/
      element :supply_button, '.menu a', text: /Supply/
      element :task_button, '.menu a', text: /Task/
      
      section :tab_nav, '.tab-nav' do
        element :supplies, 'a', text: /Supplies/
        element :projects, 'a', text: /Projects/
        element :documents, 'a', text: /Documents/
      end

      # FIXME DRY up
      sections :tasks, ".open_tasks .task" do
        element :name, '.task-title'
      end

      # FIXME DRY up
      sections :supplies, ".open_supplies .task" do
        element :name, '.task-title'
      end

      sections :projects, ".tab.projects tbody tr" do
        element :name, 'td:nth-child(1) a'
      end

      element :page_title_element, '.circle-dashboard .header .title'

      def page_title
        page_title_element.text
      end

      # FIXME DRY up
      def has_task?(task_to_find)
        tasks.any? { |task| task.name.text == task_to_find.name }
      end

      # FIXME DRY up
      def has_supply?(supply_to_find)
        supplies.any? { |supply| supply.name.text == supply_to_find.name }
      end

      def has_project?(project_to_find)
        projects.any? { |project| project.name.text == project_to_find.name }
      end

    end
  end
end