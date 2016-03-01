class Circle::Join < ::Form
  attribute :user,      :model,   primary: true
  attribute :circle_id, :integer
  attribute :location, :string, default: proc{ user.address.full_address }, required: false

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
