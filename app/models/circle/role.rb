class Circle::Role < ActiveRecord::Base
  belongs_to :circle
  belongs_to :user

  enum role_type: %w[
    circle.admin
    circle.official
    circle.custom
    circle.volunteer
    circle.helpee
  ]

  enum status: %i(pending active blocked)
  
  LEADERSHIP_TYPES = %w(circle.admin circle.official circle.custom)
  ORGANIZER_TYPES  = %w(circle.admin)
  ORGANIZER_TYPE_IDS  = ORGANIZER_TYPES.map {|id| Circle::Role.role_types[id] }

  scope :leadership, ->{ where(role_type: LEADERSHIP_TYPES.map{|id| Circle::Role.role_types[id] }) }
  scope :for_circle, ->(circle) { where(circle: circle ) }

  validates :user_id, uniqueness: { scope: [:role_type, :circle_id] }
  validates :user_id, presence: true
  validates :circle_id, presence: true

  def self.role_types_with_names
    self.role_types.keys.map do |role_type|
      [I18n.t!("roles.name.#{role_type}"), role_type]
    end
  end

  def self.leadership_role_types_with_names
    role_types_with_names.select do |(_, type)|
      LEADERSHIP_TYPES.include? type
    end
  end


  def name
    return self[:name] if self[:name].present?
    I18n.t!("roles.name.#{self.role_type}")
  end
end
