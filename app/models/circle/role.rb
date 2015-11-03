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

  LEADERSHIP_TYPES = %w(circle.admin circle.official circle.custom)

  scope :leadership, ->{ where(role_type: LEADERSHIP_TYPES.map{|id| Circle::Role.role_types[id] }) }
  scope :for_circle, ->(circle) { where(circle: circle ) }

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
    self[:name] || I18n.t!("roles.name.#{self.role_type}")
  end
end
