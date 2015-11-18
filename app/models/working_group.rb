class WorkingGroup < ActiveRecord::Base
  belongs_to :circle

  has_many :tasks, dependent: :destroy
  has_many :supplies, dependent: :destroy

  has_many :roles, dependent: :destroy

  has_many :users,   ->{ distinct }, through: :roles
  has_many :admins,  ->{ Role.admin }, through: :roles, source: :user
  has_many :members, ->{ Role.member }, through: :roles, source: :user


  validates :name, presence: true
  validates :circle, presence: true

  def underscored_name
    name.downcase.underscore.gsub(' ', '_')
  end
end
