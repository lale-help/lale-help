class Token < ActiveRecord::Base
  enum token_type: %w(
    reset_password
    simple
    task_confirmation
    task_invitation
    login
    task_completion
    supply_invitation
    supply_completion
  )

  scope :for_user_id,   ->(id) { where("context ->> 'user_id' = ?", id.to_s)}
  scope :for_circle_id, ->(id) { where("context ->> 'circle_id' = ?", id.to_s)}
  scope :active, -> { where(active: true) }

  after_initialize do
    if self.code.blank?
      begin
        self.code ||= SecureRandom.hex(64)
      end while Token.active.where(code: self.code).exists?
    end
  end
end
