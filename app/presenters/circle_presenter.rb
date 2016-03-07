class CirclePresenter < Presenter

  delegate :admins, to: :object

  include ActionView::Helpers::UrlHelper

  let(:admins_with_email_links) do
    admins.active.map { |a| mail_to(a.email, a.name) }
  end

end