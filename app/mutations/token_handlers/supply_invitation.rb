class TokenHandlers::SupplyInvitation < TokenHandler
  def handle_token(token)
    puts "HERE"
    user   = User.find(token.context['user_id'])
    supply = Supply.find(token.context['supply_id'])

    controller.login(user)


    case controller.params[:status]
    when "accept"
      Supply::Volunteer.run user: user, supply: supply
    end

    controller.redirect_to circle_supply_path(supply.circle, supply)
  end

  def reusable?
    true
  end
end