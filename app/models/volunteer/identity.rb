class Volunteer::Identity < OmniAuth::Identity::Models::ActiveRecord
  belongs_to :volunteer

  validates :email,
              presence: true,
              uniqueness: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :first_name, :last_name, :location, presence: true


  before_create do
    Authentication::VolunteerRegistration.run!(identity: self)
  end

  attr_accessor :first_name, :last_name, :location


end
