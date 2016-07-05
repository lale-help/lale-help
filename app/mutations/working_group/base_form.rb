class WorkingGroup::BaseForm < ::Form
  attribute :working_group, :model, primary: true, new_records: true

  attribute :name, :string
  attribute :description, :string, required: false
  attribute :type, :symbol, default: proc { working_group.type }, in: %i(public private)
  # only required on create, and this is checked in validate.
  # note: required: false doesn't seem to work on integers!
  attribute :organizer_id, :string, required: false

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

  def organizer_options
    working_group.circle.users.active.order(:first_name).map { |u| [u.name, u.id] }
  end

  def organizer_assignable?
    !working_group.persisted?
  end

  class Submit < ::Form::Submit

    private

    def update_attributes
      attrs = {
        name:        name,
        description: description,
        is_private:  (type == :private)
      }
      working_group.update_attributes(attrs)
    end

    def assign_organizer
      initial_organizer = User.find(organizer_id)
      working_group.roles.admin.find_or_create_by!(user: initial_organizer)
    end

    # see child classes
    # def execute
    # end

  end
end
