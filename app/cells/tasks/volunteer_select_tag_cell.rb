#
# renders a select tag to select volunteers for a task.
#
class Tasks::VolunteerSelectTagCell < ::ViewModel

  attr_accessor :group_public, :group_members, :non_group_members, :volunteers

  include ERB::Util

  def initialize(task, options)
    @group_public   = !task.working_group.is_private?
    @volunteers     = task.volunteers
    circle_members  = task.circle.users.active.order(:first_name)
    @group_members, @non_group_members = circle_members.partition do |user| 
      task.working_group.users.include?(user)
    end
  end

  # this is the default cell action
  def show
    opts = { multiple: true, include_blank: t('.assignee_blank'), placeholder: 'by name' }
    select_tag('new_volunteer_id', select_options, opts)
  end

  private 

  def select_options
    if group_public
      optgroup_tags(group_members, label: t('.in_working_group')) + 
        optgroup_tags(non_group_members, label: t('.all_helpers'))
    else
      option_tags(group_members)
    end
  end

  def optgroup_tags(users, label:)
    content_tag('optgroup', label: label) { option_tags(users) }
  end

  def option_tags(users)
    users.map do |user|
      attributes = {value: user.id, disabled: volunteers.include?(user) }
      content_tag(:option, html_escape(user.name), attributes)
    end.join
  end

end