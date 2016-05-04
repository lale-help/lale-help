class WorkingGroup < ActiveRecord::Base
  belongs_to :circle

  has_many :tasks, dependent: :destroy
  has_many :supplies, dependent: :destroy

  has_many :projects, dependent: :destroy

  has_many :roles, dependent: :destroy

  has_many :users,   ->{ distinct.extending(UserAssociationExtension) }, through: :roles
  has_many :admins,  ->{ Role.admin }, through: :roles, source: :user
  has_many :members, ->{ Role.member }, through: :roles, source: :user

  scope :asc_order, -> { order('lower(working_groups.name) ASC') }
  scope :for_circle, ->(circle) { where(circle: circle ) }

  validates :name, presence: true
  validates :circle, presence: true
  validates_uniqueness_of :name, scope: :circle


  def underscored_name
    name.downcase.underscore.gsub(' ', '_')
  end

  def type
    is_private? ? :private : :public
  end
end
