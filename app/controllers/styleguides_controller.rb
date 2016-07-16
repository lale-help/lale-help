class StyleguidesController < ApplicationController
  skip_authorization_check

  def index
    render :index, layout: 'styleguide'
  end
  
  def show
    layout = params['layout'] || 'internal'
    render params[:id], layout: layout
  end
end
