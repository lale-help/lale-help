#
# FIXME review Circle, WorkingGroup and Project Dashboard page
# for refactorings/extractions.
# 
module PageObject
  module WorkingGroup
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}/working_groups/{wg_id}{?as}'

      section :add_menu, PageObject::Component::AddMenu, '#sidebar'
      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'

      sections :tasks, ".open_tasks .task" do
        element :name, '.task-title'
      end

      sections :supplies, ".open_supplies .task" do
        element :name, '.task-title'
      end

      sections :projects, ".tab.projects tbody tr" do
        element :name, 'td:nth-child(1) a'
      end

      sections :files, ".tab.documents tbody tr" do
        element :name, 'td:nth-child(1) a'
      end

      element :headline, '.collection-dashboard .header .title'

      def has_task?(task_to_find)
        tasks.any? { |task| task.name.text == task_to_find.name }
      end

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