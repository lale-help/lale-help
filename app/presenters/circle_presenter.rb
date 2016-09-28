class CirclePresenter < Presenter

  delegate :admins, to: :object

  include ActionView::Helpers::UrlHelper

  let(:admins_with_email_links) do
    admins.active.map { |a| mail_to(a.email, a.name) }
  end

  let(:active_circle_links) do
    current_user.active_circles.map do |circle|
      link_to(circle.name, account_switch_circle_path(current_user, circle_id: circle.id))
    end
  end

  def current_user
    @context
  end

end
