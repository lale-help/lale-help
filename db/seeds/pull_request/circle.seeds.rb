# ---- WARNING ----
# This file creates an **admin** user.
# This should never be run on any staging or production environment

location = Location.find_or_create_by(
    geocode_query: 'Munich',
    latitude: 48.1351253,
    longitude: 11.5819806,
    timezone: 'Europe/Berlin'
)
if location.geocode_data.nil?
  location.geocode_data={"address_components"=>
                             [{"long_name"=>"Munich", "short_name"=>"Munich", "types"=>["locality", "political"]},
                              {"long_name"=>"Upper Bavaria", "short_name"=>"Upper Bavaria", "types"=>["administrative_area_level_2", "political"]},
                              {"long_name"=>"Bavaria", "short_name"=>"BY", "types"=>["administrative_area_level_1", "political"]},
                              {"long_name"=>"Germany", "short_name"=>"DE", "types"=>["country", "political"]}],
                         "formatted_address"=>"Munich, Germany",
                         "geometry"=>
                             {"bounds"=>{"northeast"=>{"lat"=>48.2482197, "lng"=>11.7228755}, "southwest"=>{"lat"=>48.0616018, "lng"=>11.360796}},
                              "location"=>{"lat"=>48.1351253, "lng"=>11.5819806},
                              "location_type"=>"APPROXIMATE",
                              "viewport"=>{"northeast"=>{"lat"=>48.2482197, "lng"=>11.7228755}, "southwest"=>{"lat"=>48.0616018, "lng"=>11.360796}}},
                         "place_id"=>"ChIJ2V-Mo_l1nkcRfZixfUq4DAE",
                         "types"=>["locality", "political"]}.to_json
  location.save
end
address = Address.find_or_create_by(city: 'Munich', country: 'DE', location_id: location.id)
circle = Circle.find_or_create_by(name: "Default", address: address)
working_group = WorkingGroup.find_or_create_by(name: "Default WG", circle: circle)


# Create Admin User
admin = User.find_or_create_by(first_name: "Lale", last_name: "Admin", is_admin: true, primary_circle_id: circle.id, status: 'active')
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
  user = User.find_or_create_by(first_name: "Lale", last_name: "App#{i}", status: 'active')
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
