class Project::BaseForm < ::Form

  attribute :project, :model, primary: true, new_records: true, default: proc { circle.projects.build }

  attribute :name, :string
  attribute :description, :string, required: false
  attribute :organizer_id, :integer, default: proc { project.admin.try(:id) || user.id }
  attribute :working_group_id, :string

  attribute :circle, :model
  attribute :user, :model
  attribute :ability, :model

  def available_working_groups
    @available_working_groups ||= begin
      working_groups = circle.working_groups.asc_order.to_a
      working_groups.select! { |wg| ability.can?(:manage, wg) } unless ability.can?(:manage, circle)
      working_groups << project.working_group unless working_groups.present?
      working_groups
    end
  end

  def available_working_groups_disabled?
    !project.new_record?
  end
  
  class Submit < ::Form::Submit  

    def execute
      project.assign_attributes(project_attributes)
      project.save!
      # multiple admins may be added some time in the future
      project.roles = [ project.roles.create(role_type: 'admin', user: organizer) ]
      project
    end

    private

    def organizer
      circle.users.find(inputs[:organizer_id])
    end

    def working_group
      circle.working_groups.find(inputs[:working_group_id])
    end
    
    def project_attributes
      inputs.slice(:name, :description).merge(working_group: working_group)
    end

  end
end