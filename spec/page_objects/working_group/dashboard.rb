module PageObject
  module WorkingGroup
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}/working_groups/{wg_id}{?as}'

      element :join_button, 'a.button-primary', text: 'Join'
      element :leave_button, 'a.button-primary-inverse', text: 'Leave'

      section :add_menu, PageObject::Component::AddMenu, '#sidebar'
      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'

      section :organizers_box, PageObject::Component::UsersBox, '.users-box:nth-child(1)'
      delegate :organizers, :has_organizer?, to: :organizers_box

      section :volunteers_box, PageObject::Component::UsersBox, '.users-box:nth-child(2)'
      delegate :volunteers, :has_volunteer?, to: :volunteers_box

      section :task_list, PageObject::Component::RichItemsList, ".open_tasks"
      delegate :has_task?, :tasks, to: :task_list
      element :add_task_button, 'a.button-secondary-inverted', text: 'Add Task'

      section :supplies_list, PageObject::Component::RichItemsList, ".open_supplies"
      delegate :has_supply?, :supplies, to: :supplies_list
      element :add_supply_button, 'a.button-secondary-inverted', text: 'Add Supply'

      section :projects_list, PageObject::Component::RichItemsList, ".tab.projects .open_projects"
      delegate :has_project?, :projects, to: :projects_list

      section :files_list, PageObject::Component::OtherItemsList, ".tab.documents tbody"
      delegate :has_file?, :files, to: :files_list
      element :add_document_button, 'a.button-primary', text: 'New Document'

      section :header, PageObject::Component::CollectionDashboardHeader, '.collection-dashboard .header'
      delegate :headline, :description, to: :header

    end
  end
end