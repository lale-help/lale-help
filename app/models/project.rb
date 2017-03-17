class Project < ActiveRecord::Base
  include Commentable

  belongs_to :working_group
  has_one :circle, through: :working_group

  validates :name, presence: true, uniqueness: { scope: :working_group }
  validates :working_group_id, presence: true

  has_many :roles, dependent: :destroy

  has_many :users,  -> { distinct }, through: :roles
  has_many :admins, -> { Role.admin }, through: :roles, source: :user

  has_many :files, class_name: FileUpload, as: :uploadable, dependent: :destroy

  scope :asc_order, -> { order('lower(projects.name) ASC') }
  scope :open,      -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  def admin
    admins.first
  end

  def tasks
    Task.for_project(self)
  end

  def supplies
    Supply.for_project(self)
  end

  def members
    (tasks.map(&:users) + supplies.map(&:users)).flatten.uniq
  end

  def complete!
    update_attribute(:completed_at, Time.now)
  end

  def complete?
    !!completed_at
  end

  def open!
    update_attribute(:completed_at, nil)
  end

  def open?
    !completed_at
  end

  # active admins are: project admins whose role in the **circle** is active.
  # project roles have no status.
  def active_admins
    admins.select {|admin| circle.has_active_user?(admin) }
  end

  def start_date
    dates = []
    dates << tasks.minimum(:start_date)
    # quick hack: if no task has a start date, use the earliest end date.
    dates << tasks.minimum(:due_date)
    dates << supplies.minimum(:due_date)
    dates.compact.min
  end

  def due_date
    dates = []
    dates << tasks.maximum(:due_date)
    dates << supplies.maximum(:due_date)
    dates.compact.max
  end

end
