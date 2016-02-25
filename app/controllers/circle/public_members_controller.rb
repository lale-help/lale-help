class Circle::PublicMembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle

  before_action :ensure_logged_in

  def index
    circle_organizers = User.
      select('users.id, count(*) as role_count').
      joins(:circle_roles).
      where(circle_roles: { role_type: Circle::Role::ORGANIZER_TYPE_IDS, circle: current_circle }).
      group('users.id')

    working_group_organizers = User.
      select('users.id, count(*) as role_count').
      joins(:working_group_roles).
      where(working_group_roles: { role_type: WorkingGroup::Role::ORGANIZER_TYPE_IDS, working_group_id: current_circle.working_groups }).
      group('users.id')

    counts = (circle_organizers + working_group_organizers).each_with_object(Hash.new) do |user, obj|
      obj[user.id] ||= 0
      obj[user.id] += user.role_count
    end

    all_organizers = User.where(id: counts.keys).includes(:identity, :working_groups, :circle_roles)

    @members = all_organizers.sort_by{|u| -counts[u.id] }
  end
end