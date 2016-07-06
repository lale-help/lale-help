class Circle < ActiveRecord::Base
  attr_accessor :location_text

  has_many :roles
  has_many :users,      -> { distinct.extending(UserAssociationExtension)                      }, through: :roles
  has_many :admins,     -> { Role.send('circle.admin').extending(UserAssociationExtension)     }, through: :roles, source: :user
  has_many :officials,  -> { Role.send('circle.official').extending(UserAssociationExtension)  }, through: :roles, source: :user
  has_many :volunteers, -> { Role.send('circle.volunteer').extending(UserAssociationExtension) }, through: :roles, source: :user
  has_many :leadership, -> { Role.leadership.extending(UserAssociationExtension)               }, through: :roles, source: :user
  
  has_many :organizers, -> { distinct }, through: :working_groups, source: :admins

  has_many :working_groups

  has_many :tasks, through: :working_groups
  has_many :supplies, through: :working_groups
  has_many :projects, through: :working_groups

  has_many :sponsorships
  has_many :sponsors, through: :sponsorships

  has_many :files, class_name: FileUpload, as: :uploadable

  belongs_to :address, autosave: true


  # Validations
  validates :name, presence: true
  validates :address, presence: true


  # Hooks
  after_initialize :build_association_defaults

  enum language: [:en, :de, :fr]

  def active_organizers
    organizers.joins(:circle_roles).where(circle_roles: { status: Circle::Role.statuses[:active] })
  end

  def admin
    admins.first
  end

  def user_count
    users.count
  end

  def has_active_user?(user)
    roles.active.exists?(user: user)
  end

  def has_blocked_user?(user)
    roles.blocked.exists?(user: user)
  end

  def open_task_count
    tasks.count
  end

  def current_sponsors
    sponsorships.current.includes(:sponsor).map(&:sponsor)
  end

  private

  def build_association_defaults
    build_address unless address.present?
  end

end
