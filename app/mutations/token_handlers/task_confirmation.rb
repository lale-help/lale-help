class TokenHandlers::TaskConfirmation < TokenHandler
  def handle_token(token)
    user = User.find(token.context['user_id'])
    task = Task.find(token.context['task_id'])

    controller.login(user)

    if controller.params[:status] == "decline"
      Task::Decline.run user: user, task: task
    end

    controller.redirect_to circle_task_path(task.circle, task)
  end
end