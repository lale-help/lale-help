class Task < ActiveRecord::Base
  has_many :volunteer_memberships, -> { where(organizer: false) }, class_name: 'TaskVolunteer'
  has_many :organizer_memberships, -> { where(organizer: true) }, class_name: 'TaskVolunteer'

  has_many :volunteers, through: :volunteer_memberships, class_name: 'Volunteer'
  has_many :organizers, through: :organizer_memberships, class_name: 'Volunteer'

  belongs_to :working_group
  belongs_to :discussion

  has_many :task_taggings, class_name: '::TaskTagging'
  has_many :task_tags, through: :task_taggings, class_name: '::TaskTag'

  has_many :task_locations, class_name: '::TaskLocaton'
  has_many :locations, through: :task_locations, class_name: '::Location'

end
