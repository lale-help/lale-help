class CirclePresenter < Presenter

  delegate :active_admins, to: :object

  include ActionView::Helpers::UrlHelper

  let(:admins_with_email_links) do
    active_admins.map { |a| mail_to(a.email, a.name) }
  end

end