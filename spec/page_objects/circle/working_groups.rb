module PageObject
  module Circle
    class WorkingGroups < PageObject::Page

      set_url '/circles/{circle_id}/admin/working_groups'

      # FIXME right now there's no distinction between active and inactive wgs in the selector 
      sections :working_groups, '.wg-table tbody tr' do
        element :name, '.name a'
        elements :organizers, '.admins li'
      end

    end
  end
end