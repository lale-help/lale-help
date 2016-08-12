class StyleguideController < ApplicationController
  skip_authorization_check

  def show
    render :show, layout: 'public'
  end

end
