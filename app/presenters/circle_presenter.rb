class CirclePresenter < Presenter

  delegate :admins, to: :object

  include ActionView::Helpers::UrlHelper

  let(:admins_with_email_links) do
    admins.active.map { |a| mail_to(a.email, a.name) }
  end

  let(:active_circle_links) do
    @context.active_circles.map { |c| link_to(c.name, switch_circle_path(c)) }
  end

end