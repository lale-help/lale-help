module PageObject
  module Circle
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}{?as}'

      section :add_menu, PageObject::Component::AddMenu, '#sidebar'

      section :tab_nav, '.tab-nav' do
        element :supplies, 'a', text: /Supplies/
        element :projects, 'a', text: /Projects/
        element :documents, 'a', text: /Documents/
      end

      # FIXME review if it should be DRYed up
      sections :tasks, ".open_tasks .task" do
        element :name, '.task-title'
      end

      # FIXME review if it should be DRYed up
      sections :supplies, ".open_supplies .task" do
        element :name, '.task-title'
      end

      # FIXME review if it should be DRYed up
      sections :projects, ".tab.projects tbody tr" do
        element :name, 'td:nth-child(1) a'
      end

      # FIXME review if it should be DRYed up
      sections :files, ".tab.documents tbody tr" do
        element :name, 'td:nth-child(1) a'
      end

      element :page_title_element, '.circle-dashboard .header .title'

      def page_title
        page_title_element.text
      end

      # FIXME review if it should be DRYed up
      def has_task?(task_to_find)
        tasks.any? { |task| task.name.text == task_to_find.name }
      end

      # FIXME review if it should be DRYed up
      def has_supply?(supply_to_find)
        supplies.any? { |supply| supply.name.text == supply_to_find.name }
      end

      def has_project?(project_to_find)
        projects.any? { |project| project.name.text == project_to_find.name }
      end

      def has_file?(file_to_find)
        files.any? { |file| file.name.text == file_to_find.name }
      end

    end
  end
end