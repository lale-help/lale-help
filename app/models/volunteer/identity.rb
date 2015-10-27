class Volunteer::Identity < OmniAuth::Identity::Models::ActiveRecord
  attr_accessor :commit, :first_name, :last_name, :location, :circle_id
  belongs_to :circle
  belongs_to :volunteer

  validates :email,
              presence: true,
              uniqueness: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  # validates :first_name, :last_name, :location, presence: true
  # validates :circle_id, presence: { message: 'You must choose a circle' }, unless: :creating_new_circle?

  # before_create do
  #   Authentication::VolunteerRegistration.run!(identity: self)
  # end

  def creating_new_circle?
    commit && commit.downcase == "create a circle"
  end
end
