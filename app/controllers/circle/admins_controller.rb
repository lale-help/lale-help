class Circle::AdminsController < ApplicationController
  include HasCircle

  def show
    authorize! :manage, current_circle
  end
end