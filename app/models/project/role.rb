class Project::Role < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:role_type, :project_id] }

  enum role_type: %w[admin]

end