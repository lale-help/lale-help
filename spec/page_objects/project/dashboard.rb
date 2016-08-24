module PageObject
  module Project
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}/projects/{project_id}{?as}'

      include HasItemDetailsTable

      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'
      
      section :header, PageObject::Component::CollectionDashboardHeader, '.collection-dashboard .header'
      delegate :headline, :description, to: :header

      section :task_list, PageObject::Component::TaskablesList, "#project-tasks-list"
      delegate :has_task?, :tasks, to: :task_list

      section :supplies_list, PageObject::Component::TaskablesList, "#project-supplies-list"
      delegate :has_supply?, :supplies, to: :supplies_list

      element :invite_working_group_button, '.button-secondary', text: 'Invite working group'
      element :invite_circle_button, '.button-secondary', text: 'Invite circle'
    end
  end
end