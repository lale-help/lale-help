class WorkingGroup::BaseForm < ::Form
  attribute :working_group, :model, primary: true, new_records: true

  attribute :name, :string
  attribute :description, :string, required: false
  attribute :admin_ids, :array, class: String, default: proc{ working_group.admins.active.map(&:id) }
  attribute :type, :symbol, default: proc{ working_group.type }, in: %i(public private)


  def new_url
    circle_working_groups_path(working_group.circle)
  end

  def update_url
    circle_working_group_path(working_group.circle, working_group)
  end

  def admin_options
    working_group.circle.users.active.map { |u|
      [u.name, u.id]
    }
  end

  def type_options
    [
      [ I18n.t('working_group.types.public'),  :public  ],
      [ I18n.t('working_group.types.private'), :private ]
    ]
  end

  class Submit < ::Form::Submit
    def execute
      working_group.update_attributes inputs.slice(:name, :description)

      working_group.is_private = type == :private

      working_group.save
    end

    def clean_admin_ids
      admin_ids.keep_if(&:present?).map(&:to_i)
    end
  end
end