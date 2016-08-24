class ProjectMailer < BaseMandrillMailer

  def project_invitation(project, user)
    build_message(user.language, user.email) do
      merge_vars(user, project).merge(
        "WORKGROUP"                => project.working_group.name,
        "PROJECT_URL"              => handle_token_url(user.login_token.code, redirect: circle_project_url(project.circle, project)),
        "PROJECT_TASK_NUMBER"      => project.tasks.not_completed.count,
        "PROJECT_HELPERS_REQUIRED" => project.tasks.to_a.sum(&:missing_volunteer_count)
      )
    end
  end

  private

  def merge_vars(user, project)
    {
      "FIRST_NAME"          => user.first_name,
      "PROJECT_TITLE"       => project.name,
      "PROJECT_DESCRIPTION" => project.description,
      "PROJECT_ORGANIZER"   => project.admin.name,
      "CIRCLE_NAME"         => project.circle.name
    }
  end
end