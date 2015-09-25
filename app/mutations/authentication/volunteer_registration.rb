class Authentication::VolunteerRegistration < Mutations::Command
  required do
    model :identity, class: Volunteer::Identity, new_records: true
  end

  def execute
    location = Location.find_or_create_by!(name: identity.location)
    identity.volunteer = Volunteer.create!(first_name: identity.first_name, last_name: identity.last_name)
  end
end