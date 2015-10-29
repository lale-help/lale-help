class Circle < ActiveRecord::Base
  attr_accessor :location_text

  has_many :working_groups
  has_many :members, class_name: 'User'
  has_many :tasks, through: :working_groups

  belongs_to :location

  belongs_to :admin, class_name: 'User' #TODO: remove in favor of roles

  validates :name, presence: true
  validates :admin, presence: true
  validates :location, presence: true
  attr_accessor :location_text

  before_save :determine_location
  after_initialize  :determine_location

  def user_count
    members.count
  end

  def open_task_count
    tasks.count
  end

  private
  def determine_location
    if location_text.present?
      self.location = Location.location_from location_text
    end
  end
end
