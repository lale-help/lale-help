class Circle::CalendarsController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle
  include HasWorkingGroupFilters

  def show
  end
end