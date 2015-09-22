class Discussion::Message < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :volunteer
end
