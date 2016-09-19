class WorkingGroup < ActiveRecord::Base

  enum status: %i(active disabled)

  belongs_to :circle

  has_many :tasks, dependent: :destroy
  has_many :supplies, dependent: :destroy

  has_many :projects, dependent: :destroy

  has_many :roles, dependent: :destroy

  has_many :users,   ->{ distinct }, through: :roles
  has_many :admins,  ->{ Role.admin }, through: :roles, source: :user
  has_many :members, ->{ Role.member }, through: :roles, source: :user

  has_many :files, class_name: FileUpload, as: :uploadable, dependent: :destroy

  scope :asc_order, -> { order('lower(working_groups.name) ASC') }
  scope :for_circle, ->(circle) { where(circle: circle ) }

  validates :name, presence: true, uniqueness: { scope: :circle }
  validates :circle, presence: true

  # active admins are: working group admins whose role in the **circle** is active.
  # working group roles have no status.
  def active_admins
    admins.select { |admin| circle.has_active_user?(admin) }
  end

  def active_users
    users.select { |user| circle.has_active_user?(user) }
  end

  def underscored_name
    name.downcase.underscore.gsub(' ', '_')
  end

  def type
    is_private? ? :private : :public
  end
end
