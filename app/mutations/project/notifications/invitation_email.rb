class Project::Notifications::InvitationEmail < Mutations::Command
  required do
    model :project
    model :current_user, class: User
    string :type
  end

  def execute
    volunteers.each do |user|
      next unless user.email.present?
      ProjectMailer.project_invitation(project, user).deliver_now
    end

    OpenStruct.new(volunteers: volunteers)
  end

  private

  def volunteers
    @volunteers ||= begin
      volunteers = (type == "circle" ? project.circle.volunteers : project.working_group.users)
      volunteers.active.to_a.reject { |u| u == current_user }
    end
  end
end