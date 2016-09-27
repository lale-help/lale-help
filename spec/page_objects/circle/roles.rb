module PageObject
  module Circle
    class Roles < PageObject::Page

      set_url '/circles/{circle_id}/admin/roles{?as}'
      element :promote_user_link, 'a', text: /Promote User/
      element :save_role_button, 'input[type=submit][value=Save]'

      sections :admins, '.default-table tbody tr' do
        element :role, 'td:nth-child(1)'
        element :name, 'td:nth-child(2)'
        element :status, 'td:nth-child(3)'
        element :remove_button, 'a.delete'
      end

      def has_admin?(admin_to_find)
        admins.any? do |admin| 
          admin.name.text == admin_to_find.name &&
          admin.role.text == 'Admin' &&
          admin.status.text == 'Active'
        end
      end

    end
  end
end