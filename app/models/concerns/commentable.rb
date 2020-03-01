module Commentable

  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :item, dependent: :destroy
  end

end
