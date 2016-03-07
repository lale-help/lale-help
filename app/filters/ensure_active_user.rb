class EnsureActiveUser

  class << self

    def before(c) # c = controller
      return unless c.current_user
      if (c.current_user.pending? && c.current_user.has_circles?)
        c.redirect_to c.membership_pending_circle_member_path
      end
    end

  end

end