class Circle < ActiveRecord::Base
  has_many :working_groups
  has_many :volunteers, through: :working_groups

  has_many :discussions, through: :working_groups

  has_many :tasks, through: :working_groups

  belongs_to :location
  belongs_to :admin, class_name: 'Volunteer'
end
