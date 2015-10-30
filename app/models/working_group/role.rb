class WorkingGroup::Role < ActiveRecord::Base
  belongs_to :working_group
  belongs_to :user

  enum role_type: %w[
    working_group.admin
    working_group.member
  ]

  scope :admin, -> { send('working_group.admin') }

  scope :for_circle, ->(circle){ for_group(circle.working_groups) }
  scope :for_group, ->(group){ where(working_group: group ) }

  def name
    self[:name] || I18n.t!("roles.name.#{self.role_type}")
  end
end
