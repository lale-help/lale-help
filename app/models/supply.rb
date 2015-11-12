class Supply < ActiveRecord::Base
  include Completable
  include Task::Common

  # Associations
  belongs_to :location

  def due_date_text
    due_date.strftime("%A %-d %B %Y")
  end

end
