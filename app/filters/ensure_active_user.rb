class EnsureActiveUser

  class << self

    def before(c) # c = controller
      # FIXME
      # handle case user is not in circle at all
      # handle blocked user
      return unless c.current_user && c.try(:current_circle)
      if c.current_circle.has_active_user?(c.current_user) || on_pending_member_page?(c)
        return
      else
        c.redirect_to pending_member_page_path(c)
      end
    end

    private

    def on_pending_member_page?(c)
      c.request.fullpath == pending_member_page_path(c)
    end
    
    def pending_member_page_path(c)
      c.membership_pending_public_circle_path(c.current_circle)
    end

  end

end