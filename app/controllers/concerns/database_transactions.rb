module DatabaseTransactions
  extend ActiveSupport::Concern
  included do
    around_action :wrap_in_transaction, if: :should_wrap_in_transaction?
  end

  def wrap_in_transaction
    ActiveRecord::Base.transaction do
      yield if block_given?
    end
  end

  def should_wrap_in_transaction?
    request.put? || request.patch? || request.post?
  end
end