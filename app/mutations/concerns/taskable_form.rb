module TaskableForm
  extend ActiveSupport::Concern

  included do
    attribute :working_group, :model
    attribute :working_group_id, :string

    attribute :project_id,       :string, required: false
    attribute :project,          :model, required: false, default: proc { project_id.present? ? Project.find(project_id) : nil }
  end

  def working_group_id
    @working_group_id ||= working_group.id
  end

  def working_group
    @working_group ||= begin
      primary_object.working_group || available_working_groups.first
    end
  end


  def available_working_groups
    @available_working_groups ||= begin
      if project.present?
        [ project.working_group ]
      else
        working_groups = circle.working_groups.asc_order.to_a
        working_groups.select! { |wg| ability.can?(:manage, wg) } unless ability.can?(:manage, circle)
        working_groups << primary_object.working_group unless working_groups.present?
        working_groups
      end
    end
  end

  def working_group_disabled?
    if primary_object.new_record?
      available_working_groups.size == 1
    else
      true
    end
  end

  def project_disabled?
    project.present?
  end

  def project_select(form)
    # what a ridiculous method dear Rails boys!
    form.grouped_collection_select(
      :project_id,
      available_working_groups,
      :projects,
      :name,
      :id,
      :name,
      { include_blank: I18n.t('circle.tasks.form.project_blank') },
      { disabled: project.present? }
    )
  end
end