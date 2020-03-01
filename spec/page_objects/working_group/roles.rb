module PageObject
  module WorkingGroup
    class Roles < PageObject::Page

      set_url '/circles/{circle_id}/working_groups/{wg_id}/edit/{role_type}{?as}'

      sections :users, '.default-table tr' do
        element :name, 'td:nth-child(1)'
        element :remove_button, 'a', text: 'Remove'
      end

      element :no_users, 'td.empty'

      element :user_dropdown, '#working_group_user_id'
      element :add_button, 'input[type=submit][value=Add]'

      def initialize(circle, working_group, admin)
        @circle, @working_group, @admin = circle, working_group, admin
      end

      def load_for(role_type)
        load(circle_id: @circle.id, wg_id: @working_group.id, role_type: role_type, as: @admin.id)
      end

      def organizers
        users.map { |u| u.name.text.gsub(/^[A-Z]{2} /, '') }
      end

      # syntax sugar for the spec only
      alias :volunteers :organizers

    end
  end
end