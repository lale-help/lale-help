class Discussion < ActiveRecord::Base
  belongs_to :working_group
  has_many :tasks

  has_many :messages

  has_many :volunteer_watchings
  has_many :watchers, through: :volunteer_watchings, source: :volunteer
end
