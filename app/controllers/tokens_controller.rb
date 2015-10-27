class TokensController < ApplicationController
  skip_authorization_check

  def handle_token
    outcome = TokenHandler.handle(params[:token_code], self)

    unless outcome.success?
      logger.warn "Unable to handle token #{params[:token_code]}: #{outcome.errors.message_list}"
      redirect_to root_url, alert: "Sorry, cannot handle that token."
    end
  end
end