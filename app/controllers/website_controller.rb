class WebsiteController < ApplicationController
  skip_authorization_check
  layout 'circle_page'

  def index

  end

  def ping
    render text: "PONG"
  end

  def stylesheet

  end

  def signup

  end
end
