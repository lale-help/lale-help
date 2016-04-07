#
# shared code for the Task and Supply forms/mutations
#
module Taskable::Form

  extend ActiveSupport::Concern

  def taskable_name
    taskable.model_name.singular
  end

  def working_group
    @working_group ||= begin
      new_working_group = circle.working_groups.find_by(id: working_group_id) || taskable.working_group
      if ability.can? :"create_#{taskable_name}", new_working_group
        new_working_group
      else
        taskable.working_group
      end
    end
  end

  def available_working_groups
    @available_working_groups ||= begin
      working_groups = circle.working_groups.asc_order.to_a
      working_groups.select! { |wg| ability.can?(:manage, wg) } unless ability.can?(:manage, circle)
      working_groups << taskable.working_group unless working_groups.present?
      working_groups
    end
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
      {include_blank: I18n.t('circle.taskable.form.project_blank')}
    )
  end

  def available_working_groups_disabled?
    if taskable.new_record?
      available_working_groups.size == 1 && ability.cannot?(:manage, available_working_groups.first)
    else
      true
    end
  end

end