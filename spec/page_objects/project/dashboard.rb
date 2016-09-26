module PageObject
  module Project
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}/projects/{project_id}{?as}'

      include HasItemDetailsTable

      section :edit_menu, PageObject::Component::EditMenu, '.project-edit-menu'

      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'
      
      section :header, PageObject::Component::CollectionDashboardHeader, '.collection-dashboard .header'
      delegate :headline, :description, to: :header

      section :task_list, PageObject::Component::RichItemsList, ".open_tasks"
      delegate :has_task?, :tasks, to: :task_list

      section :supplies_list, PageObject::Component::RichItemsList, ".open_supplies"
      delegate :has_supply?, :supplies, to: :supplies_list

      element :invite_working_group_button, '.button-secondary', text: 'Invite working group'
      element :invite_circle_button, '.button-secondary', text: 'Invite circle'

      def completed?
        headline.text =~ /^Done: /
      end

      def open?
        !completed?
      end
    end
  end
end