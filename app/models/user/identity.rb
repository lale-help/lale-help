class User::Identity < OmniAuth::Identity::Models::ActiveRecord
  attr_accessor :commit, :first_name, :last_name, :mobile_phone, :home_phone, :location, :circle_id, :public_profile

  belongs_to :circle
  belongs_to :user

  validates :email,
              presence: true,
              uniqueness: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  after_initialize do
    self.user ||= User.new
  end

  before_save :normalize_email

  delegate :first_name, :last_name, :mobile_phone, :home_phone, :location, :primary_circle_id, :admin?, :public_profile, to: :user

  def creating_new_circle?
    commit && commit.downcase == "create a circle"
  end

  private

  def normalize_email
    self.email = self.email.downcase
  end
end
