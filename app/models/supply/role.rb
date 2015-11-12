class Supply::Role < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  enum role_type: %w[
    supply.organizer
    supply.volunteer
    supply.suggestee
  ]

  scope :with_role, ->(role_name) { where(role_type: role_types[role_name]) }


  def name
    self[:name] || I18n.t!("roles.name.#{self.role_type}")
  end
end
