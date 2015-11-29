class Circle::Join < ::Form
  attribute :user,      :model,   primary: true
  attribute :location,  :string,  default: proc{ user.location.address unless user.location.nil? }
  attribute :circle_id, :integer


  class Submit < ::Form::Submit
    def execute
      circle = Circle.find(circle_id)

      unless role.where(user: user, circle: circle).exists?
        role.create(user: user, circle: circle)
      end

      user.update_attribute :primary_circle, circle

      circle
    end

    def role
      Circle::Role.send('circle.volunteer')
    end
  end
 end