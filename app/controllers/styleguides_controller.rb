class StyleguidesController < ApplicationController
  skip_authorization_check

  def show
    layout = params['layout'] || 'internal'
    render params[:id], layout: layout
  end
end
