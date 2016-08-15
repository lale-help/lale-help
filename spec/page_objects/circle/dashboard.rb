module PageObject
  module Circle
    class Dashboard < PageObject::Page

      set_url '/circles/{circle_id}?as={as_id}'

      element :h1_title, '.circle-dashboard .header .title'
      elements :tasks, ".task-list .task"

      def page_title
        h1_title.text
      end

    end
  end
end