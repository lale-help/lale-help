module Completable
  extend ActiveSupport::Concern

  included do
    scope :completed,     -> { where("completed_at IS NOT NULL") }
    scope :not_completed, -> { where("completed_at IS NULL") }
  end

  def complete= val
    self.completed_at = Time.now if val.to_s == "true"
  end

  def complete?
    completed_at.present?
  end

  def incomplete?
    !complete?
  end
end
