class Project < ActiveRecord::Base

  belongs_to :working_group
  has_one :circle, through: :working_group
  
  validates :name, presence: true
  
  validates :working_group_id, presence: true
  validates_uniqueness_of :name, scope: :working_group

  has_many :roles, dependent: :destroy

  has_many :users,   ->{ distinct }, through: :roles
  has_many :admins,  ->{ Role.admin }, through: :roles, source: :user

  scope :asc_order, -> { order('lower(projects.name) ASC') }

  def tasks
    Task.for_project(self)
  end

  def supplies
    Supply.for_project(self)
  end

end
