# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

  v = User.create(first_name: "Lale", last_name: "App")
  l = Location.create(name: "Munich")
  c = Circle.create(name: "Default", location: l, admin: v)
  w = WorkingGroup.create(name: "Default WG", circle: c)

  t = Task.create(name: "demo task", working_group: w, volunteers: [v])
