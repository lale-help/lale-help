class Circle < ActiveRecord::Base
  attr_accessor :location_text

  has_many :working_groups
  has_many :volunteers
  has_many :tasks, through: :working_groups

  belongs_to :location
  belongs_to :admin, class_name: 'Volunteer'

  validates :name, presence: true
  validates :location, presence: true

  before_save :determine_location
  after_initialize  :determine_location

  def volunteer_count
    volunteers.count
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
