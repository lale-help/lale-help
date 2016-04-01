class Project::BaseForm < ::Form

  attribute :project, :model, primary: true, new_records: true
  attribute :working_group, :model #, default: proc{ Circle.new }
  attribute :circle, :model #, default: proc{ Circle.new }
  attribute :user, :model

  attribute :working_group_id, :string
  # FIXME
  attribute :organizer_id, :integer, default: proc { project.admins.first.try(:id) || user.id }

  attribute :name, :string
  attribute :description, :string, required: false

  attribute :ability, :model

  def available_working_groups
    @available_working_groups ||= begin
      working_groups = circle.working_groups.asc_order.to_a
      working_groups.select! { |wg| ability.can?(:manage, wg) } unless ability.can?(:manage, circle)
      working_groups << project.working_group unless working_groups.present?
      working_groups
    end
  end

  def working_group
    WorkingGroup.find(working_group_id)
    # FIXME is this relevant in project context?
    # @working_group ||= begin
    #   new_working_group = circle.working_groups.find_by(id: working_group_id) || task.working_group
    #   if ability.can? :create_task, new_working_group
    #     new_working_group
    #   else
    #     task.working_group
    #   end
    # end
  end
  
  # FIXME
  def available_working_groups_disabled?
    false
  end
  
  class Submit < ::Form::Submit  

    def organizer
      circle.users.find(inputs[:organizer_id])
    end

    def execute
      project.assign_attributes(project_attributes.merge(working_group: working_group))
      project.save!
      # reset roles for now
      # FIXME discuss UI for project roles management
      project.roles = [
        project.roles.create(role_type: 'admin', user: organizer)
      ]
      project
    end

    private

    def project_attributes
      inputs.slice(:name, :description)
    end
  end
end