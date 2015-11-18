class Circle < ActiveRecord::Base
  attr_accessor :location_text

  has_many :roles
  has_many :users,      ->{ distinct }, through: :roles

  has_many :admins,     ->{ Circle::Role.send('circle.admin')     }, through: :roles, source: :user
  has_many :officials,  ->{ Circle::Role.send('circle.official')  }, through: :roles, source: :user
  has_many :volunteers, ->{ Circle::Role.send('circle.volunteer') }, through: :roles, source: :user
  has_many :leadership, ->{ Circle::Role.leadership }, through: :roles, source: :user

  has_many :working_groups, -> { order('lower(working_groups.name) ASC') }
  has_many :tasks, through: :working_groups
  has_many :supplies, through: :working_groups

  belongs_to :location


  # Validations
  validates :name, presence: true
  validates :location, presence: true


  # Hooks
  before_save :determine_location
  after_initialize  :determine_location

  def user_count
    users.count
  end

  def open_task_count
    tasks.count
  end

  private
  def determine_location
    if location_text.present?
      self.location ||= Location.location_from(location_text)
    end
  end
end
