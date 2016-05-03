class Circle < ActiveRecord::Base
  attr_accessor :location_text

  module RoleStatusExtension
    def active
      with_status(:active)
    end
    def pending
      with_status(:pending)
    end
    def with_status(status)
      circle = proxy_association.owner
      # association_name will be users, admins, volunteers, etc.
      association_name = proxy_association.reflection.delegate_reflection.name
      circle.send(association_name).where(circle_roles: {status: Circle::Role.statuses[status]})
    end
  end

  has_many :roles
  has_many :users,      ->{ distinct.extending(RoleStatusExtension) }, through: :roles
  has_many :admins,     ->{ Circle::Role.send('circle.admin').extending(RoleStatusExtension)     }, through: :roles, source: :user
  has_many :officials,  ->{ Circle::Role.send('circle.official').extending(RoleStatusExtension)  }, through: :roles, source: :user
  has_many :volunteers, ->{ Circle::Role.send('circle.volunteer').extending(RoleStatusExtension) }, through: :roles, source: :user
  has_many :leadership, ->{ Circle::Role.leadership.extending(RoleStatusExtension) }, through: :roles, source: :user

  has_many :working_groups
  has_many :organizers,   -> { distinct }, through: :working_groups, source: :admins

  has_many :tasks, through: :working_groups
  has_many :supplies, through: :working_groups
  has_many :projects, through: :working_groups

  belongs_to :address, autosave: true


  # Validations
  validates :name, presence: true
  validates :address, presence: true


  # Hooks
  after_initialize :build_association_defaults

  enum language: [:en, :de, :fr]

  def admin
    admins.first
  end
  
  def user_count
    users.count
  end

  def has_active_user?(user)
    roles.active.exists?(user: user)
  end

  def open_task_count
    tasks.count
  end

  # FIXME methods left here only for demo purposes
  def active_members
    users.active
  end

  def active_admins
    admins.active
  end

  def pending_members
    users.pending
  end

  def active_volunteers
    volunteers.active
  end

  def active_organizers
    organizers.active
  end

  private

  def build_association_defaults
    build_address unless address.present?
  end
end
