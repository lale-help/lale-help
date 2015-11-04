class Circle::SuppliesController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle

  def index
  end
end