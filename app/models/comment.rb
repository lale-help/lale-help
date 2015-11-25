class Comment < ActiveRecord::Base
  belongs_to :commenter, class_name: 'User'
  belongs_to :task, polymorphic: true

  validates :commenter, presence: true
  validates :task, presence: true
  validates :body, presence: true
end
