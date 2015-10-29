class Authentication::UserFromOmniAuth < Mutations::Command
  required do
    string :provider
    string :uid
  end

  def execute
    case provider
    when 'identity'
      User::Identity.find(uid).user
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end