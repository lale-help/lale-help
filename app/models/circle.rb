class Circle < ActiveRecord::Base
  has_many :working_groups
  has_many :volunteers

  has_many :tasks, through: :working_groups

  belongs_to :location
  belongs_to :admin, class_name: 'Volunteer'

  validates :name, presence: true
  attr_accessor :location_text

  before_save :determine_location

  private
  def determine_location
    self.location = Location.location_from location_text if location_text.present?
  end
end
