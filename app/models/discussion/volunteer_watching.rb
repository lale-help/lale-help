class Discussion::VolunteerWatching < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :discussion
end
