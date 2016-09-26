module PageObject
  class Component
    class TaskablesList < PageObject::Component

      sections :items, '.task' do
        element :name, '.item-title'
      end

      def has_item?(item_to_find)
        items.any? { |item| item.name.text == item_to_find.name }
      end

      alias :has_task? :has_item?
      alias :tasks :items
      
      alias :has_supply? :has_item?
      alias :supplies :items

      alias :has_project? :has_item?
      alias :projects :items

    end
  end
end