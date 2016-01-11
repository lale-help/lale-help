class TokenHandlers::TaskCompletion < TokenHandler
  def handle_token(token)
    user = User.find(token.context['user_id'])
    task = Task.find(token.context['task_id'])

    controller.login(user)

    if controller.params[:status] == "completed"
      Task::Complete.run user: user, task: task
    end

    controller.redirect_to circle_task_path(task.circle, task)
  end
end