class Project < ActiveRecord::Base

  belongs_to :working_group
  has_one :circle, through: :working_group
  
  validates :name, presence: true, uniqueness: { scope: :working_group }  
  validates :working_group_id, presence: true

  has_many :roles, dependent: :destroy

  has_many :users,   ->{ distinct }, through: :roles
  has_many :admins,  ->{ Role.admin }, through: :roles, source: :user

  scope :asc_order, -> { order('lower(projects.name) ASC') }

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

  # active admins are: project admins whose role in the **circle** is active. 
  # project roles have no status.
  def active_admins
    admins.select {|admin| circle.has_active_user?(admin) }
  end

end
