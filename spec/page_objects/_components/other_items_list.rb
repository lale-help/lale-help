module PageObject
  class Component
    class OtherItemsList < PageObject::Component

      sections :items, 'tr' do
        element :name, 'td:nth-child(1) a'
      end

      def has_item?(item_to_find)
        items.any? { |item| item.name.text == item_to_find.name }
      end

      alias :has_project? :has_item?
      alias :projects :items

      alias :has_file? :has_item?
      alias :files :items

    end
  end
end