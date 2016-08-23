module PageObject
  module Project
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}/projects/{project_id}{?as}'

      include HasItemDetailsTable

      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'

      element :headline, '.collection-dashboard .header .title'
      element :description, '.collection-dashboard .header .description'

      # FIXME DRY - warning selectors are different!
      sections :tasks, "#project-tasks-list .task" do
        element :name, '.task-title'
      end

      # FIXME DRY
      sections :supplies, "#project-supplies-list .task" do
        element :name, '.task-title'
      end

      # FIXME DRY
      def has_task?(task_to_find)
        tasks.any? { |task| task.name.text == task_to_find.name }
      end

      # FIXME DRY
      def has_supply?(supply_to_find)
        supplies.any? { |supply| supply.name.text == supply_to_find.name }
      end

    end
  end
end