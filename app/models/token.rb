class Token < ActiveRecord::Base
  enum token_type: ["reset_password"]

  scope :reset_password, -> { where(token_type: 'reset_password') }
  scope :for_user_id, ->(user_id) { where("context ->> 'user_id' = ?", user_id.to_s)}

  after_initialize do
    self.code ||= SecureRandom.hex(64)
  end
end
