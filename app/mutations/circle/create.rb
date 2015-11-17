class Circle::Create < ::Form
  attribute :circle, :model, primary: true, default: proc{ Circle.new }, new_records: true
  attribute :user,   :model

  attribute :name,      :string
  attribute :location,  :string,  default: proc{ user.location.address }


  class Submit < ::Form::Submit
    def execute
      circle.assign_attributes inputs.slice(:name)
      circle.location = Location.location_from(location)

      circle.save

      Circle::Role.send('circle.admin').create(circle: circle, user: user)
      Circle::Role.send('circle.volunteer').create(circle: circle, user: user)

      user.update_attribute :primary_circle, circle

      circle
    end

  end
 end