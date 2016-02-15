class Circle::DiscussionsController < ApplicationController
  before_action :ensure_logged_in
  skip_authorization_check # TODO: REMOVE

  include HasCircle

  def index
  end
end