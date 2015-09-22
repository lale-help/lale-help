class DiscussionMessage < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :volunteer
end
