module PageObject
  class Component
    class UsersBox < PageObject::Component

      element :title, '.title'
      elements :users, '.user-name-shortened'

      def has_user?(user_to_find)
        users.any? { |user| user.text == user_to_find.name }
      end

      alias :has_organizer? :has_user?
      alias :organizers :users
      
      alias :has_volunteer? :has_user?
      alias :volunteers :users
    end
  end
end