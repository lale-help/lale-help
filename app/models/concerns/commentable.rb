module Commentable
  extend ActiveSupport::Concern
  included do
    klass = self

    has_many :comments,    as: :item

  end

end
