class TokenHandlers::CircleInvite < TokenHandler
  def handle_token(token)
    if current_user.present?
      Circle::Join::Submit.run(user: current_user, circle_id: token.context['circle_id'])
      redirect_to circle_path(token.context['circle_id'])

    else
      redirect_to root_path
    end
  end

  def reusable?
    true
  end
end