class TokenHandlers::Login < TokenHandler
  def handle_token(token)
    user = User.find(token.context['user_id'])

    controller.login(user)

    redirect = controller.params[:redirect]

    if redirect.present?
      controller.redirect_to(redirect)
    else
      controller.redirect_to(circle_path(current_user.primary_circle))
    end

  end

  def reusable?
    true
  end
end