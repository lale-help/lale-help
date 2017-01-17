class Comment < ActiveRecord::Base
  default_scope { order('created_at DESC') }

  belongs_to :commenter, class_name: 'User'
  belongs_to :item, polymorphic: true

  validates :commenter, presence: true
  validates :item, presence: true
  validates :body, presence: true

  scope :human, -> { where.not(commenter_id: Comment::AutoComment.commenter.id)}

  def comment_date_time
    I18n.l(created_at, format: "%A %-d %B %Y %H:%M")
  end
end
