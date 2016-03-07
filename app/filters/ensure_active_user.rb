class EnsureActiveUser

  class << self

    def before(c) # c = controller
      return unless c.current_user
      if (c.current_user.pending? && c.current_user.has_circles? && !on_pending_member_page?(c))
        c.redirect_to pending_member_page_path(c)
      end
    end

    private

    def on_pending_member_page?(c)
      c.request.fullpath == pending_member_page_path(c)
    end
    
    def pending_member_page_path(c)
      circle = c.current_user.primary_circle
      c.membership_pending_circle_member_path(circle, c.current_user)
    end

  end

end