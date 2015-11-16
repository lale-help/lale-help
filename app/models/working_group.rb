class WorkingGroup < ActiveRecord::Base
  belongs_to :circle

  has_many :tasks
  has_many :supplies

  has_many :roles
  has_many :users,      ->{ distinct }, through: :roles
  has_many :admins,     ->{ Role.send('working_group.admin')     }, through: :roles, source: :user
  has_many :volunteers, ->{ Role.send('working_group.volunteer') }, through: :roles, source: :user


  validates :name, presence: true
  validates :circle, presence: true

  def underscored_name
    name.downcase.underscore.gsub(' ', '_')
  end
end
