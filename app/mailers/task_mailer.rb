class TaskMailer < BaseMandrillMailer
  def task_reminder(task, user, token)
    build_message(user.language, user.email) do
      merge_vars(user, task).merge({
        "TASK_UNASSIGN_URL" => handle_token_url(token.code, status: :decline),
        "TASK_CONFIRM_URL"  => handle_token_url(token.code, status: :confirm)
      })
    end
  end

  private

  def merge_vars user, task
    {
      "FIRST_NAME"            => user.first_name,
      "TASK_TITLE"            => task.name,
      "TASK_DESCRIPTION"      => task.description,
      "TASK_DUE_DATE"         => task.due_date_and_time,
      "TASK_TIME_REQUIRED"    => task.duration_text,
      "TASK_HELPERS_REQUIRED" => task.volunteers.map(&:name).join(", ")
    }
  end
end