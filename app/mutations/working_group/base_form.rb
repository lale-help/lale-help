class WorkingGroup::BaseForm < ::Form
  attribute :working_group, :model, primary: true, new_records: true

  attribute :name, :string
  attribute :admin_ids, :array, class: String, default: proc{ working_group.admins.map(&:id) }


  def new_url
    circle_working_groups_path(working_group.circle)
  end

  def update_url
    circle_working_group_path(working_group.circle, working_group)
  end



  def admin_options
    working_group.circle.users.map { |u|
      [u.name, u.id]
    }
  end

  class Submit < ::Form::Submit
    def execute
      working_group.update_attributes inputs.slice(:name)
      working_group.roles.admin.delete_all
      clean_admin_ids.each do |id|
        working_group.roles.admin.create user_id: id
      end
      working_group.save
    end

    def clean_admin_ids
      admin_ids.keep_if(&:present?).map(&:to_i)
    end
  end
end