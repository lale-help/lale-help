class Circle::CreateCircle < Mutations::Command
   required do
     model  :user, class: User
     string :name
     string :location_name
   end

   optional do
   end

   def execute
     Circle.transaction do
       # lookup location
       location = Location.location_from location_name

       # create circle
       circle   = Circle.create! name: name, location: location

       # Add user as an admin
       Circle::Role.send('circle.admin').create( circle: circle, user: user)

       # log a system event
       SystemEvent.create! user: user, for: circle, action: :created

       circle
     end
   end
 end