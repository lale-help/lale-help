class TokenHandlers::SupplyInvitation < TokenHandler
  def handle_token(token)
    puts "HERE"
    user   = User.find(token.context['user_id'])
    supply = Supply.find(token.context['supply_id'])

    controller.login(user)


    case controller.params[:status]
    when "accept"
      volunteer_for_supply(user, supply)
    end

    controller.redirect_to circle_supply_path(supply.circle, supply)
  end

  def volunteer_for_supply user, supply
    if controller.can?(:volunteer, supply)
      outcome = Supply::Volunteer.run(user: user, supply: supply)

      if outcome.success?
        controller.flash[:notice] = I18n.t("supplies.flash.volunteered")
      else
        controller.flash[:error] = I18n.t("supplies.flash.volunteer_failed")
      end

    else
      controller.flash[:notice] = I18n.t("supplies.flash.already_taken")
    end
  end

  def reusable?
    true
  end
end