class WebsiteController < ApplicationController
  def ping
    render text: "PONG"
  end
end