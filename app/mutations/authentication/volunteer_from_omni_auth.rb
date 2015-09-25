class Authentication::VolunteerFromOmniAuth < Mutations::Command
  required do
    string :provider
    string :uid
  end

  def execute
    case provider
    when 'identity'
      Volunteer::Identity.find(uid).volunteer
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end