module PageObject
  module Circle
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}{?as}'

      section :add_menu, PageObject::Component::AddMenu, '#sidebar'
      delegate :has_no_add_button?, to: :add_menu

      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'

      section :task_list, PageObject::Component::TaskablesList, ".open_tasks"
      delegate :has_task?, :tasks, to: :task_list

      section :supplies_list, PageObject::Component::TaskablesList, ".open_supplies"
      delegate :has_supply?, :supplies, to: :supplies_list

      section :projects_list, PageObject::Component::OtherItemsList, ".tab.projects tbody"
      delegate :has_project?, :projects, to: :projects_list

      section :files_list, PageObject::Component::OtherItemsList, ".tab.documents tbody"
      delegate :has_file?, :files, to: :files_list

      section :header, PageObject::Component::CollectionDashboardHeader, '.collection-dashboard .header'
      delegate :headline, :description, to: :header

    end
  end
end