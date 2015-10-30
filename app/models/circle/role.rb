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

  scope :leadership, ->{ where(role_type: %w(circle.admin circle.official circle.custom)) }
  scope :for_circle, ->(circle) { where(circle: circle ) }

  def name
    self[:name] || I18n.t!("roles.name.#{self.role_type}")
  end
end
