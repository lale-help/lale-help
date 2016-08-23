module PageObject
  class Component
    class TaskablesList < PageObject::Component

      sections :taskables, '.task' do
        element :name, '.task-title'
      end

      def has_taskable?(item_to_find)
        taskables.any? { |item| item.name.text == item_to_find.name }
      end

      alias :has_task? :has_taskable?
      alias :tasks :taskables
      
      alias :has_supply? :has_taskable?
      alias :supplies :taskables

    end
  end
end