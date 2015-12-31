class Token < ActiveRecord::Base
  enum token_type: %w(
    reset_password
    simple
    task_confirmation
  )

  scope :for_user_id, ->(user_id) { where("context ->> 'user_id' = ?", user_id.to_s)}

  after_initialize do
    self.code ||= SecureRandom.hex(64)
  end
end
