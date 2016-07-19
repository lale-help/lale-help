class WorkingGroup::Role < ActiveRecord::Base
  belongs_to :working_group
  belongs_to :user

  enum role_type: %w[
    admin
    member
  ]

  ORGANIZER_TYPES = %w(admin)
  ORGANIZER_TYPE_IDS  = ORGANIZER_TYPES.map {|id| WorkingGroup::Role.role_types[id] }

  validates :user_id, uniqueness: { scope: [:role_type, :working_group_id] }

  scope :for_circle, ->(circle){ for_group(circle.working_groups) }
  scope :for_group, ->(group){ where(working_group: group ) }

  def name
    self[:name] || I18n.t!("roles.name.#{self.role_type}")
  end
end
