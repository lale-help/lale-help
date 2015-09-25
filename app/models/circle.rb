class Circle < ActiveRecord::Base
  attr_accessor :location_text

  has_many :working_groups
  has_many :volunteers
  has_many :tasks, through: :working_groups

  belongs_to :location
  belongs_to :admin, class_name: 'Volunteer'

  validates :name, presence: true
  validates :location_text, presence: true

  before_save :determine_location

  def volunteer_count
    volunteers.count
  end

  def open_task_count
    tasks.count
  end

  private
  def determine_location
    self.location = Location.location_from location_text if location_text.present?
  end
end
