class User::Identity < OmniAuth::Identity::Models::ActiveRecord
  attr_accessor :commit, :first_name, :last_name, :location, :circle_id

  belongs_to :circle
  belongs_to :user

  validates :email,
              presence: true,
              uniqueness: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  after_initialize do
    self.user ||= User.new
  end

  delegate :first_name, :last_name, :location, :primary_circle_id, to: :user

  def creating_new_circle?
    commit && commit.downcase == "create a circle"
  end
end
