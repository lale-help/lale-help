class User::UpdatePassword < Mutations::Command
  required do
    model  :user
    string :password
    string :password_confirmation
  end

  def execute
    return if password_invalid

    identity = user.identity
    identity.password = password
    identity.save!
  end

  def password_invalid
    add_error(:password_confirmation, :did_not_match) if password != password_confirmation
    add_error(:password, :too_short)                  if password.size < 8
    add_error(:password, :no_upper)                   if password && /[[:upper:]]/.match(password).nil?
    add_error(:password, :no_lower)                   if password && /[[:lower:]]/.match(password).nil?
    add_error(:password, :no_numeric)                 if password && /[[:digit:]]/.match(password).nil?

    has_errors?
  end
end
