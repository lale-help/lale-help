class TokenHandlers::TaskInvitation < TokenHandler
  def handle_token(token)
    user = User.find(token.context['user_id'])
    task = Task.find(token.context['task_id'])

    controller.login(user)


    case controller.params[:status]
    when "accept"
      Task::Volunteer.run user: user, task: task
    when "decline"
      Task::Decline.run user: user, task: task
    end

    controller.redirect_to circle_task_path(task.circle, task)
  end

  def reusable?
    true
  end
end