#
# FIXME review Circle, WorkingGroup and Project Dashboard page
# for refactorings/extractions.
# 
module PageObject
  module Circle
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}{?as}'

      section :add_menu, PageObject::Component::AddMenu, '#sidebar'
      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'

      section :task_list, PageObject::Component::TaskablesList, ".open_tasks"
      delegate :has_task?, :tasks, to: :task_list

      section :supplies_list, PageObject::Component::TaskablesList, ".open_supplies"
      delegate :has_supply?, :supplies, to: :supplies_list

      sections :projects, ".tab.projects tbody tr" do
        element :name, 'td:nth-child(1) a'
      end

      sections :files, ".tab.documents tbody tr" do
        element :name, 'td:nth-child(1) a'
      end

      section :header, PageObject::Component::CollectionDashboardHeader, '.collection-dashboard .header'
      delegate :headline, :description, to: :header

      def has_project?(project_to_find)
        projects.any? { |project| project.name.text == project_to_find.name }
      end

      def has_file?(file_to_find)
        files.any? { |file| file.name.text == file_to_find.name }
      end

    end
  end
end