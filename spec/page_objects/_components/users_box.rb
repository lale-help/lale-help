module PageObject
  class Component
    class UsersBox < PageObject::Component

      element :title, '.title'
      elements :users, '.user-name-shortened'

      element :invite_working_group_button, '.button-secondary', text: "Invite working group"
      element :invite_circle_button, '.button-secondary', text: "Invite circle"
      
      def has_user?(user_to_find)
        users.any? { |user| user.text == user_to_find.name }
      end

      alias :has_organizer? :has_user?
      alias :organizers :users

      alias :has_volunteer? :has_user?
      alias :volunteers :users

      alias :has_helper? :has_user?
      alias :helpers :users
    end
  end
end