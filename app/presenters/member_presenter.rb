class MemberPresenter < Presenter

  include ActionView::Helpers::UrlHelper

  delegate :about_me, :name, :email, :home_phone, :mobile_phone, :circles,
    to: :model

  name_object :model

  RESOURCE_PATHS_MAP = {
    'Circle':       ->(e, scope) { scope.send(:roles_circle_admin_path, e) },
    'WorkingGroup': ->(e, scope) { scope.send(:circle_working_group_edit_organizers_path, e.circle, e) },
    'Task':         ->(e, scope) { scope.send(:edit_circle_task_path, e.circle, e) },
    'Supply':       ->(e, scope) { scope.send(:edit_circle_supply_path, e.circle, e) },
    'Project':      ->(e, scope) { scope.send(:edit_circle_project_path, e.circle, e) }
  }

  let(:circle) do
    @options[:circle]
  end

  let(:address) do
    _.address.full_address if _.address.present?
  end

  # TODO mark if profile is public, mark primary circle
  let(:circle_links) do
    links = _.circles.map { |circle| @context.link_to_circle(circle) }
    links.to_sentence.html_safe
  end

  let(:circle_working_groups) do
    _.working_groups.for_circle(circle)
  end

  let(:circle_tasks) do
    _.tasks.for_circle(circle)
  end

  let(:circle_supplies) do
    _.supplies.for_circle(circle)
  end

  let(:working_group_links) do
    links = circle_working_groups.map { |wg| @context.link_to_working_group(wg) }
    links.to_sentence.html_safe
  end

  def member_since(format: :long)
    format_date(_.created_at, format: format)
  end

  def last_login(format: :long)
    if _.last_login.present?
      format_date(_.last_login, format: format)
    end
  end

  let(:help_provided_count) do
    _.tasks.for_circle(circle).completed.count +
      _.supplies.for_circle(circle).completed.count
  end

  let(:link_to_last_helped_item) do
    if last_helped_item
      text = I18n.l(last_helped_item.completed_at.to_date, format: :default)
      @context.link_to_taskable(last_helped_item, text: text)
    end
  end

  let(:last_helped_item) do
    tasks    = circle_tasks.volunteered.completed
    supplies = circle_supplies.volunteered.completed
    (tasks + supplies).max_by(&:completed_at)
  end

  let(:last_helped_at) do
    if last_helped_item && last_helped_item.completed_at
      I18n.l(last_helped_item.completed_at.to_date)
    end
  end

  let(:language) do
    I18n.t(_.language, scope: 'language')
  end

  def accredited_until(format: :long)
    if circle_volunteer_role.accredited_until
      format_date(circle_volunteer_role.accredited_until, format: format)
    else
      I18n.t('circle.members.show.not_accredited')
    end
  end

  # By convention, store the accredited_until only on the volunteer role.
  # It would be best to fix the DB structure. Only have one circle membership,
  # which stores the accredited_until flag; but joins in the roles, etc.
  def circle_volunteer_role
    _.circle_volunteer_roles.find_by(circle: circle)
  end

  def stringify_organizer_role(resource)
    link_text = "#{resource.model_name.human} #{resource.try(:name) || resource.try(:title)}"
    @context.link_to(link_text, resource_path(resource), target: :blank)
  end

  def resource_path(resource)
    RESOURCE_PATHS_MAP.fetch(resource.class.to_s.to_sym).call(resource, self)
  end

  let(:stringified_organizer_roles) do
    organizer_roles.map {|role| stringify_organizer_role(role) }
  end

  let(:has_organizer_roles?) do
    !organizer_roles.empty?
  end

  let(:organizer_roles) do
    roles_for_circle + roles_for_working_groups + roles_for_tasks +
      roles_for_supplies + roles_for_projects
  end

  let(:roles_for_circle) do
    roles = circle.roles.send("circle.admin").active
    (roles.count == 1 && roles.exists?(user: @object)) ? [circle] : []
  end

  let(:roles_for_working_groups) do
    circle.working_groups.select do |wg|
      (wg.active_admins.count == 1 && wg.active_admins.first == @object)
    end
  end

  let(:roles_for_tasks) do
    circle.tasks.incomplete.select { |t| t.organizer == @object }
  end

  let(:roles_for_supplies) do
    circle.supplies.incomplete.select { |s| s.organizer == @object }
  end

  let(:roles_for_projects) do
    circle.projects.select { |p| p.admin == @object }
  end

  def format_date(date, format:)
    I18n.l(date.to_date, format: format)
  end
end
