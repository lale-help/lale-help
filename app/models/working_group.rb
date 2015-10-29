class WorkingGroup < ActiveRecord::Base
  has_many :tasks
  has_many :users, through: :tasks

  belongs_to :circle

  validates :name, presence: true
  validates :circle, presence: true

  def underscored_name
    name.downcase.underscore.gsub(' ', '_')
  end
end
