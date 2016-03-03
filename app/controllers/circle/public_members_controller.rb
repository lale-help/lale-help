class Circle::PublicMembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle

  before_action :ensure_logged_in

  def index
    members = current_circle.users.order('last_name asc')
    @members = members.where('users.public_profile = true').includes(:identity, :working_groups, :circle_roles)
    @total_members = members.count
  end

end
