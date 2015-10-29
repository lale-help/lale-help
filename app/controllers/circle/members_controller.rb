class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle
  include HasWorkingGroupFilters

  def index
  end
end