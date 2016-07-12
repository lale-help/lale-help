module HasCircle
  extend ActiveSupport::Concern

  included do
    layout 'internal'
    helper_method :current_circle
    helper_method :current_circle_sponsor
  end

  def current_circle
    return @circle if defined? @circle
    return unless params[:circle_id].present? || params[:id].present?

    @circle = begin
      circle_id = params[:circle_id] || params[:id]
      Circle.find(circle_id)
    end
  end

  #
  # If a circle has more than one sponsor, we want to show their logos alternatingly.
  # 
  # We decided to keep showing the same sponsor for one user session (login) -- 
  # this is easy to implement and doesn't distract the user with changing logos
  # per request / from time to time.
  # 
  # The sponsor needs to be stored per circle though, since a user can be 
  # in multiple circles.
  # 
  def current_circle_sponsor
    key = "circle_#{current_circle.id}_sponsor_id"
    # only store the sponsor's id in the session; session has limited space and will be serialized.
    session[key] ||= begin
      if current_circle.sponsorships.current.present?
        current_circle.sponsorships.current.sample.sponsor.id
      end
    end
    # cache the sponsor instance for one http request
    # do this with a "soft" find_by(id: ) so we don't get an exception if the sponsor has been deleted.
    @current_circle_sponsor ||= Sponsor.find_by(id: session[key])
  end
  
end
