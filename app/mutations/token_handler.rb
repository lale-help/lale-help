class TokenHandler < Mutations::Command
  include Rails.application.routes.url_helpers

  required do
    model :token
    duck   :controller, methods: [:redirect_to, :login]
  end

  def execute
    ActiveRecord::Base.transaction do
      handle_token(token)

      token.update_attribute :active, false
    end
  end

  def self.handle(token_code, controller)
    token = Token.where(active: true).find_by(code: token_code)
    lookup_handler(token.token_type).run(token: token, controller: controller)
  end

  def self.lookup_handler id
    "TokenHandlers::#{id.classify}".constantize
  end
end