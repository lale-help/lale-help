class TaskMailer < BaseMandrillMailer
  def task_reminder(task_id, user_id, token_code)
    task = Task.find(task_id)
    user = User.find(user_id)
    build_message(user.language, user.email, task.organizer.try(:email)) do
      merge_vars(user, task).merge(
        "TASK_UNASSIGN_URL" => handle_token_url(token_code, status: :decline),
        "TASK_CONFIRM_URL"  => handle_token_url(token_code, status: :confirm)
      )
    end
  end


  def task_completion_reminder(task_id, user_id, token_code)
    task = Task.find(task_id)
    user = User.find(user_id)
    build_message(user.language, user.email, task.organizer.try(:email)) do
      merge_vars(user, task).merge(
        "TASK_MARK_COMPLETE_URL" => handle_token_url(token_code, status: :completed),
        "TASK_ADD_COMMENT_URL"   => handle_token_url(token_code)
      )
    end
  end


  def task_invitation(task_id, user_id, token_code)
    task = Task.find(task_id)
    user = User.find(user_id)
    build_message(user.language, user.email, task.organizer.try(:email)) do
      merge_vars(user, task).merge(
        "WORKGROUP"        => task.working_group.name,
        "TASK_URL"         => handle_token_url(token_code),
        "TASK_ACCEPT_URL"  => handle_token_url(token_code, status: :accept),
        "TASK_DECLINE_URL" => handle_token_url(token_code, status: :decline)
      )
    end
  end


  def task_change(task_id, user_id, changes)
    task = Task.find(task_id)
    return unless task.circle.notify_on_task_change?
    user = User.find(user_id)
    build_message(user.language, user.email, task.organizer.try(:email)) do
      merge_vars(user, task).merge(
        "TASK_REVIEW_URL" => handle_token_url(user.login_token.code, redirect: circle_task_url(task.circle, task)),
        "TASK_CHANGES"    => changes.keys.map { |key| Task.human_attribute_name(key) }.to_sentence(locale: user.language)
      )
    end
  end

  def task_comment(task_id, comment_id, user_id)
    task = Task.find(task_id)
    return unless task.circle.notify_on_task_comment?
    comment = Comment.find(comment_id)
    user = User.find(user_id)
    build_message(user.language, user.email, task.organizer.try(:email)) do
      merge_vars(user, task).merge(
        "TASK_COMMENT"    => comment.body,
        "TASK_REVIEW_URL" => handle_token_url(user.login_token.code, redirect: circle_task_url(task.circle, task)),
        "COMMENT_AUTHOR"  => comment.commenter.name
      )
    end
  end

  def task_assigned(task_id, user_id)
    task = Task.find(task_id)
    user = User.find(user_id)
    build_message(user.language, user.email, task.organizer.try(:email)) do
      merge_vars(user, task).merge(
        "WORKGROUP"       => task.working_group.name,
        "TASK_REVIEW_URL" => handle_token_url(user.login_token.code, redirect: circle_task_url(task.circle, task))
      )
    end
  end

  def task_unassigned(task_id, user_id)
    task = Task.find(task_id)
    user = User.find(user_id)
    build_message(user.language, user.email, task.organizer.try(:email)) do
      merge_vars(user, task).merge(
        "WORKGROUP"       => task.working_group.name,
        "TASK_REVIEW_URL" => handle_token_url(user.login_token.code, redirect: circle_task_url(task.circle, task))
      )
    end
  end

  private

  def merge_vars(user, task)
    task = ::TaskPresenter.new(task)
    {
      "FIRST_NAME"            => user.first_name,
      "TASK_TITLE"            => task.name,
      "TASK_DESCRIPTION"      => task.description(length: 100),
      "TASK_DUE_DATE"         => task.formatted_date,
      "TASK_TIME_REQUIRED"    => task.duration_text,
      "TASK_HELPERS_REQUIRED" => task.volunteer_count_required,
      "TASK_URL_MAIN"         => handle_token_url(user.login_token.code, redirect: circle_task_url(task.circle, task)),
      "CIRCLE_NAME"           => task.circle.name,
      "TASK_ORGANIZER"        => task.organizer.try(:name)
    }
  end
end
