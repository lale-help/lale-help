class StyleguidesController < ApplicationController
  def show
    layout = params['layout'] || 'circle_page'
    render params[:id], layout: layout
  end
end
