class Project::Role < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  enum role_type: %w[admin]

end