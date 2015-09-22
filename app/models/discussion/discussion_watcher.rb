class DiscussionWatcher < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :discussion
end
