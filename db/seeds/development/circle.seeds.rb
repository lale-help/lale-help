# ---- WARNING ----
# This file creates an **admin** user.
# This should never be run on any staging or production environment

location = Location.find_or_create_by(
    geocode_query: 'Munich',
    latitude: 48.1351253,
    longitude: 11.5819806,
    timezone: 'Europe/Berlin'
   )
Address.reset_callbacks(:save)
address = Address.find_or_create_by(city: 'Munich', country: 'DE', location_id: location.id)
circle = Circle.find_or_create_by(name: "Default", address: address)
working_group = WorkingGroup.find_or_create_by(name: "Default WG", circle: circle)


# Create Admin User
admin = User.find_or_create_by(first_name: "Lale", last_name: "Admin", is_admin: true, primary_circle_id: circle.id, status: :active)
if admin.identity.nil?
  User::Identity.create(user_id: admin.id, email: "admin@lale.help", password: "Example1234")
end
if admin.address.nil?
  admin.address = Address.create(city: 'Munich', country: 'DE', location_id: location.id)
  admin.save
end
role = Circle::Role.send('circle.admin')
role.find_or_create_by(user: admin, circle: circle)
working_group.roles.admin.find_or_create_by! user: admin


# Create some volunteer users
(1..5).each do |i|
  user = User.find_or_create_by(first_name: "Lale", last_name: "App#{i}", status: :active)
  if user.identity.nil?
    User::Identity.create(user_id: user.id, email: "user#{1}@lale.help", password: "Example1234")
  end
  if user.address.nil?
    user.address = Address.create(city: 'Munich', country: 'DE', location_id: location.id)
    user.save
  end
  role = Circle::Role.send('circle.volunteer')
  role.find_or_create_by(user: user, circle: circle)
end
