class MemberPresenter < Presenter

  include ActionView::Helpers::UrlHelper

  let(:circle) do
    @context
  end

  PATH_MAP = {
    'Circle':       ->(e, scope) { scope.send(:roles_circle_admin_path, e) },
    'WorkingGroup': ->(e, scope) { scope.send(:circle_working_group_edit_organizers_path, e.circle, e) },
    'Task':         ->(e, scope) { scope.send(:edit_circle_task_path, e.circle, e) },
    'Supply':       ->(e, scope) { scope.send(:edit_circle_supply_path, e.circle, e) },
    'Project':      ->(e, scope) { scope.send(:edit_circle_project_path, e.circle, e) }
  }

  def stringify_organizer_role(entity)
    link_text = "#{entity.model_name.human} #{entity.try(:name) || entity.try(:title)}"
    link_to(link_text, entity_path(entity), target: :blank)
  end

  def entity_path(entity)
    PATH_MAP.fetch(entity.class.to_s.to_sym).call(entity, self)
  end

  let(:stringified_organizer_roles) do
    organizer_roles.map {|role| stringify_organizer_role(role) }
  end

  let(:has_organizer_roles?) do
    !organizer_roles.empty?
  end

  let(:organizer_roles) do
    for_circle + for_working_groups + for_tasks + for_supplies + for_projects
  end

  let(:for_circle) do
    roles = circle.roles.send("circle.admin").active
    (roles.count == 1 && roles.exists?(user: @object)) ? [circle] : []
  end

  let(:for_working_groups) do
    circle.working_groups.select do |wg|
      (wg.active_admins.count == 1 && wg.active_admins.first == @object)
    end
  end

  let(:for_tasks) do
    circle.tasks.incomplete.select { |t| t.organizer == @object }
  end

  let(:for_supplies) do
    circle.supplies.incomplete.select { |s| s.organizer == @object }
  end

  let(:for_projects) do
    circle.projects.select { |p| p.admin == @object }
  end

end