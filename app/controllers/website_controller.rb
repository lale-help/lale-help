class WebsiteController < ApplicationController
  layout 'circle_page'

  def index

  end

  def ping
    render text: "PONG"
  end

  def stylesheet

  end
end
