require 'faker'
require 'factory_girl'

unless Rails.env.development? || Rails.env.pull_request?
  raise "This file creates an **admin** user and dummy data. It should never be run on a staging or production environment."
end

def default_working_group
  WorkingGroup.find_by(name: 'Default WG')
end

def fake_user
  first, last = Faker::StarWars.character.split(" ", 2)
  last  = last || "of Nil"
  email = "#{first.downcase.gsub(' ', '-')}.#{last.downcase.gsub(' ', '-')}@lale.help"
  OpenStruct.new(first: first, last: last, email: email)
end

# create admin user
admin = User::Identity.find_by(email: 'admin@lale.help').try(:user)
if admin.nil?
  admin = User::Create.new(
    first_name:            'Lale',
    last_name:             'Admin',
    email:                 'admin@lale.help',
    password:              'Example1234',
    password_confirmation: 'Example1234',
    accept_terms:          true,
    language:              User.languages[:en]
  ).submit.result
  admin.update_attributes(is_admin: true)
end

# create circle
circle = Circle.find_by(name: 'Default')
if circle.nil?
  circle = Circle::CreateForm.new(
    name:                'Default',
    city:                'Munich',
    country:             'DE',
    language:            'en',
    user:                admin,
    must_activate_users: false,
    postal_code:         '80333'
  ).submit.result
end

if WorkingGroup.find_by(name: 'Default WG', circle_id: circle.id).nil?
  working_group = WorkingGroup::Create.new(
    organizer_id:  admin.id,
    working_group: WorkingGroup.new(circle_id: circle.id),
    name:          'Default WG',
    type:          :public
  )
  working_group.submit
  WorkingGroup::AddUserForm.new(
    working_group: working_group.working_group,
    type:          :organizer,
    user_id:       admin.id
  ).submit
end

# Create some volunteer users
users = []
loop do
  fake  = fake_user
  user = if (identity = User::Identity.find_by(email: fake.email))
    identity.user
  else
    User::Create.new(
      first_name:            fake.first,
      last_name:             fake.last,
      email:                 fake.email,
      password:              'Example1234',
      password_confirmation: 'Example1234',
      accept_terms:          true,
      language:              User.languages.values.sample
    ).submit.result
  end
  users << user
  Circle::Join.new(user: user, circle_id: circle.id).submit
  if users.count.even?
    WorkingGroup::AddUserForm.new(
      working_group: default_working_group,
      type:          :organizer,
      user_id:       user.id
    ).submit
  end
  break if users.count == 5
end