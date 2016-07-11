class Sponsorship < ActiveRecord::Base

  validates :circle_id, presence: true
  validates :sponsor_id, presence: true
  validates :starts_on, presence: true
  validates :ends_on, presence: true
  validate :ends_on_must_be_before_starts_on

  belongs_to :circle
  belongs_to :sponsor

  scope :current, -> { where("starts_on <= ? AND ends_on >= ?", Date.today, Date.today) }

  def ends_on_must_be_before_starts_on
    return unless (ends_on && starts_on) # don't interfere with other validations
    if ends_on < starts_on
      errors.add(:ends_on, "Must be on or after the start date.")
    end
  end
end
