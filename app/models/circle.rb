class Circle < ActiveRecord::Base
  attr_accessor :location_text

  has_many :roles
  has_many :users,      ->{ distinct }, through: :roles

  has_many :admins,     ->{ Circle::Role.send('circle.admin')     }, through: :roles, source: :user
  has_many :officials,  ->{ Circle::Role.send('circle.official')  }, through: :roles, source: :user
  has_many :volunteers, ->{ Circle::Role.send('circle.volunteer') }, through: :roles, source: :user
  has_many :leadership, ->{ Circle::Role.leadership }, through: :roles, source: :user

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

  # FIXME don't access Circle::Role internals
  def active_members
    users.where(circle_roles: {status: Circle::Role.statuses[:active]})
  end

  # FIXME don't access Circle::Role internals
  def active_admins
    admins.where(circle_roles: {status: Circle::Role.statuses[:active]})
  end

  # FIXME don't access Circle::Role internals
  def pending_members
    users.where(circle_roles: {status: Circle::Role.statuses[:pending]})
  end

  # FIXME don't access Circle::Role internals
  def active_volunteers
    volunteers.where(circle_roles: {status: Circle::Role.statuses[:active]})
  end

  # FIXME don't access Circle::Role internals
  def active_organizers
    organizers.where(circle_roles: {status: Circle::Role.statuses[:active]})
  end

  private

  def build_association_defaults
    build_address unless address.present?
  end
end
