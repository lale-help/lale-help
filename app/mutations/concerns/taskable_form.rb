module TaskableForm
  extend ActiveSupport::Concern

  included do
    attribute :working_group_id, :string, required: false
    attribute :working_group,    :model

    attribute :project_id,       :string, required: false
    attribute :project,          :model,  required: false, default: proc { Project.find(project_id) if project_id.present? }
  end

  def working_group
    @working_group ||= begin
      if primary_object.working_group.present?
        primary_object.working_group
      elsif working_group_id.present?
        WorkingGroup.find(working_group_id)
      else
        available_working_groups.first
      end
    end
  end


  def available_working_groups
    @available_working_groups ||= begin
      if project.present?
        [ project.working_group ]
      else
        working_groups = circle.working_groups.active.asc_order.to_a
        working_groups.select! { |wg| ability.can?(:manage, wg) } unless ability.can?(:manage, circle)
        working_groups << primary_object.working_group unless working_groups.present?
        working_groups
      end
    end
  end

  def working_group_disabled?
    primary_object.persisted? || available_working_groups.size == 1
  end

  def available_projects
    available_working_groups.map.with_object({}) { |wg, hash| hash[wg] = wg.projects.open }
  end
end
