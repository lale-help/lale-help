class WebsiteController < ApplicationController
  skip_authorization_check
  layout 'public'

  def index
  end

  def reset_password
  end
end
