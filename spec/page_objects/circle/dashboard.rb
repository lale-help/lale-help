module PageObject
  module Circle
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}?as={as_id}'

      element :page_title_element, '.circle-dashboard .header .title'
      elements :tasks, ".task-list .task"

      def page_title
        page_title_element.text
      end

    end
  end
end