class Sponsorship < ActiveRecord::Base

  validates :circle_id, presence: true
  validates :sponsor_id, presence: true
  validates :starts_on, presence: true
  validates :ends_on, presence: true

  belongs_to :circle
  belongs_to :sponsor

  scope :current, -> { where("starts_on <= ? AND ends_on >= ?", Date.today, Date.today) }
end
