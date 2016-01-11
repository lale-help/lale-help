class TokenHandlers::SupplyCompletion < TokenHandler
  def handle_token(token)
    user   = User.find(token.context['user_id'])
    supply = Supply.find(token.context['supply_id'])

    controller.login(user)

    if controller.params[:status] == "completed"
      Supply::Complete.run user: user, supply: supply
    end

    controller.redirect_to circle_supply_path(supply.circle, supply)
  end
end