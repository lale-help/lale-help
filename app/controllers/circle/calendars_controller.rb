class Circle::CalendarsController < ApplicationController
  before_action :ensure_logged_in
  skip_authorization_check # TODO: REMOVE

  include HasCircle

  def show
  end
end