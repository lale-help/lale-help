class Circle::CreateCircle < Mutations::Command
   required do
     model  :user, class: Volunteer
     string :name
     string :location_name
   end

   optional do
   end

   def execute
     Circle.transaction do
       # lookup location
       location = Location.find_or_create_by! name: location_name

       # create circle
       circle   = Circle.create! name: name, location: location, admin: user

       # log a system event
       SystemEvent.create! volunteer: user, for: circle, action: :created

       circle
     end
   end
 end