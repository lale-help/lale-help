class User::Login < ::Form
  attribute :email,    :string, default: proc{ "" }
  attribute :password, :string, default: proc{ "" }

  class Submit < ::Form::Submit
    def validate
      add_error(:password, :too_short)      if password && password.length < 8
    end

    def execute
      identity = User::Identity.authenticate({email: email}, password)
      unless identity.present? && identity.user.present?
        add_error(:login, :failed)
        return
      end

      identity.user
    end
  end
end