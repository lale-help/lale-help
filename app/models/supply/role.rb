class Supply::Role < ActiveRecord::Base
  belongs_to :supply, touch: true
  belongs_to :user

  enum role_type: %w[
    supply.organizer
    supply.volunteer
    supply.suggestee
  ]

  validates :user_id, uniqueness: { scope: [:role_type, :supply_id] }

  scope :with_role, ->(role_name) { where(role_type: role_types[role_name]) }

  def name
    self[:name] || I18n.t!("roles.name.#{self.role_type}")
  end
end
