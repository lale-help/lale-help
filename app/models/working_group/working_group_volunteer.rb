class WorkingGroupVolunteer < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :working_group
end
