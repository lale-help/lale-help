class Volunteer::Identity < OmniAuth::Identity::Models::ActiveRecord
  belongs_to :volunteer

  validates :email,
              presence: true,
              uniqueness: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

end
