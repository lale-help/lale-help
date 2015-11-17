class Circle::Update < ::Form
  attribute :circle, :model, primary: true
  attribute :user,   :model

  attribute :name,      :string
  attribute :location,  :string,  default: proc{ circle.location.address }


  class Submit < ::Form::Submit
    def execute
      circle.assign_attributes inputs.slice(:name)
      circle.location = Location.location_from(location)

      circle.save

      circle
    end

  end
 end