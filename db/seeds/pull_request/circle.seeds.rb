if Rails.env.production? || Rails.env.staging?
  raise "This file creates an **admin** user. It should never be run on a staging or production environment."
end

# Create Admin User
admin = User::Identity.find_by(email: 'admin@lale.help').try(:user)
if admin.nil?
  admin = User::Create.new(first_name: 'Lale', last_name: 'Admin',
                           email: 'admin@lale.help', password: 'Example1234',
                           password_confirmation: 'Example1234',
                           accept_terms: true, language: User.languages[:de]).submit.result
  admin.update_attributes(is_admin: true)
end
circle = Circle.find_by(name: 'Default')
if circle.nil?
  circle = Circle::CreateForm.new(name: 'Default', city: 'Munich', country: 'DE',
                                  language: 'de', user: admin,
                                  must_activate_users: false, postal_code: '80333').submit.result
end

if WorkingGroup.find_by(name: 'Default WG', circle_id: circle.id).nil?
  working_group = WorkingGroup::Create.new(working_group: WorkingGroup.new(circle_id: circle.id),
                                           name: 'Default WG', type: :public)
  working_group.submit
  WorkingGroup::AddUserForm.new(working_group: working_group.working_group, type: :organizer,
                                user_id: admin.id).submit
end


# Create some volunteer users
(1..5).each do |i|
  if User::Identity.find_by(email: "user#{i}@lale.help").nil?
    user = User::Create.new(first_name: 'Lale', last_name: "App#{i}",
                            email: "user#{i}@lale.help", password: 'Example1234',
                            password_confirmation: 'Example1234',
                            accept_terms: true, language: User.languages[:de]).submit.result
    Circle::Join.new(user: user, circle_id: circle.id).submit
  end
end
