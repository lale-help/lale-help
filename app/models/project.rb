class Project < ActiveRecord::Base

  belongs_to :working_group
  
  validates :name, presence: true
  
  validates :working_group_id, presence: true
  validates_uniqueness_of :name, scope: :working_group

end
