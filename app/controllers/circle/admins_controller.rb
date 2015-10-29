class Circle::AdminsController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle

  def show
  end
end