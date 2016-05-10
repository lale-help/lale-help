class Supply < ActiveRecord::Base
  include Completable
  include Taskable
  include Commentable

  # Associations
  belongs_to :location

  def volunteer
    volunteers.first
  end

  def on_track?
    completed_at? || volunteers.present?
  end

end
