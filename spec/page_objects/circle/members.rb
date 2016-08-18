module PageObject
  module Circle
    class Members < PageObject::Page

      set_url '/circles/{circle_id}/members{?as}'

      section :tab_nav, '.tab-nav' do
        element :organizers, 'a', text: /Organizers/
      end

      sections :users, '.member-list tbody tr' do
        element :name, '.name a'
        element :working_groups, 'td:nth-child(3)'
        element :address, 'td:nth-child(4)'
        element :email, 'td:nth-child(6)'
        element :active_since, 'td:nth-child(7)'
      end

      def has_helper?(helper)
        users.find do |user_row|
          user_row.name.text             == helper.name &&
          user_row.working_groups.text   == helper.working_groups.map(&:name).join(',') &&
          user_row.address.text          == helper.address.to_s &&
          user_row.email.text            == helper.email &&
          user_row.active_since.text     == I18n.l(helper.created_at.to_date, format: :default)
        end
      end

    end
  end
end