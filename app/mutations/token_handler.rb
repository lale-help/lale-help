class TokenHandler < Mutations::Command
  include Rails.application.routes.url_helpers

  delegate :current_user, :redirect_to, :login, to: :controller

  required do
    model :token
    duck   :controller, methods: [:current_user, :redirect_to, :login]
  end

  def execute
    ActiveRecord::Base.transaction do
      handle_token(token)
      # current_user is only available now
      # FIXME currently all token handling subclasses require a logged in user; every handler
      # does the login itself though. refactor this.
      current_user.touch(:last_login) if current_user

      token.update_attribute(:active, false) unless reusable?
    end
  end

  def reusable?
    false
  end

  def self.handle(token_code, controller)
    token = Token.where(active: true).find_by!(code: token_code)
    lookup_handler(token.token_type).run(token: token, controller: controller)

  rescue NameError
    fail_outcome :handler, :not_found, {token: token, controller: controller}

  rescue ActiveRecord::RecordNotFound
    fail_outcome :token, :not_found,   {token_code: token_code, controller: controller}
  end

  private

  def self.lookup_handler(id)
    "TokenHandlers::#{id.classify}".constantize
  end

  def self.fail_outcome(key, value, inputs)
    errors = Mutations::ErrorHash.new
    errors[key] = Mutations::ErrorAtom.new(key, value)
    Mutations::Outcome.new(false, nil, errors, inputs)
  end
end