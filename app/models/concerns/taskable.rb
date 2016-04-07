module Taskable
  extend ActiveSupport::Concern
  included do
    klass = self

    # Associations
    belongs_to :working_group
    belongs_to :project
    has_one :circle, through: :working_group

    has_many :roles

    has_many :users,       ->{ distinct                    }, through: :roles
    has_many :volunteers,  ->{ klass::Role.send("#{klass.to_s.downcase}.volunteer") }, through: :roles, source: :user
    has_many :organizers,  ->{ klass::Role.send("#{klass.to_s.downcase}.organizer") }, through: :roles, source: :user
    has_many :comments,    as: :task

    # Scopes
    scope :for_circle, ->(circle) { joins(:working_group).where(working_groups: { circle_id: circle.id } ) }
    scope :for_project, ->(project) { where(project_id: project.id) }

    scope :with_role, ->(role) { where(task_roles: {role_type: klass::Role.role_types[role]}) }

    scope :volunteered, -> { with_role("#{klass.to_s.downcase}.volunteer") }
    scope :organized,   -> { with_role("#{klass.to_s.downcase}.organizer") }
    scope :unassigned,  -> { joins("LEFT JOIN task_roles on tasks.id = task_roles.task_id AND task_roles.role_type = #{klass::Role.role_types['task.volunteer']}").group('tasks.id', 'working_groups.name').having('count(task_roles.id) < volunteer_count_required') }

    scope :ordered_by_date, -> { reorder(due_date: 'asc')}

    # Validations
    validates :name, presence: true
    validates :due_date, presence: true
    validates :description, presence: true
    validates :working_group, presence: true
    validates :project_id, numericality: true, allow_nil: true # project is optional
  end

  def organizer
    @organizer ||= organizers.first
  end
end
