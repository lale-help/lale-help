class Circle::Join < ::Form
  attribute :user,      :model,   primary: true
  attribute :circle_id, :integer
  attribute :location,  :string, default: proc{ user.address.full_address }, required: false

  class Submit < ::Form::Submit

    def execute
      join_circle(user)
      notify_circle_admins
      circle
    end

    def role
      Circle::Role.send('circle.volunteer')
    end

    private 

    def join_circle(user)
      unless role.where(user: user, circle: circle).exists?
        role.create(user: user, circle: circle)
      end
      user.update_attribute :primary_circle, circle
    end

    def notify_circle_admins
      circle.admins.each do |admin|
        token = Token.login.create!(context: { user_id: admin.id })
        UserMailer.account_activation(circle, admin, token).deliver_now
      end
    end

    def circle
      Circle.find(circle_id)
    end

  end
end
