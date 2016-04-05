class WorkingGroup::BaseForm < ::Form
  attribute :working_group, :model, primary: true, new_records: true

  attribute :name, :string
  attribute :description, :string, required: false
  attribute :type, :symbol, default: proc{ working_group.type }, in: %i(public private)

  def new_url
    circle_working_groups_path(working_group.circle)
  end

  def update_url
    circle_working_group_path(working_group.circle, working_group)
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
  end
end
