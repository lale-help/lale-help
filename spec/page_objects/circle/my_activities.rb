module PageObject
  module Circle
    class MyActivities < PageObject::Page

      set_url '/circles/{circle_id}/taskables/volunteer{?as}'

      section :tab_nav, PageObject::Component::TabNav, '.tab-nav'

      section :task_list, PageObject::Component::RichItemsList, '#my-tasks-list'
      delegate :has_task?, :tasks, to: :task_list

      section :supplies_list, PageObject::Component::RichItemsList, '#my-supplies-list'
      delegate :has_supply?, :supplies, to: :supplies_list

    end
  end
end