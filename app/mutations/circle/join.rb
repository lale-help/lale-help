class Circle::Join < ::Form
  attribute :user,      :model,   primary: true
  attribute :circle_id, :integer
  attribute :location,  :string, default: proc{ user.address.full_address }, required: false

  class Submit < ::Form::Submit

    def execute
      add_to_circle(user)
      notify_circle_admins if circle.must_activate_users?
      circle
    end

    def role
      Circle::Role.send('circle.volunteer')
    end

    private 

    def add_to_circle(user)
      unless role.where(user: user, circle: circle).exists?
        role.create(user: user, circle: circle)
      end
      status = circle.must_activate_users? ? :pending : :active
      user.update_attributes(primary_circle: circle, status: status)
    end

    def notify_circle_admins
      circle.admins.active.each do |admin|
        token = Token.login.create!(context: { user_id: admin.id })
        UserMailer.account_activation(circle, admin, token).deliver_now
      end
    end

    def circle
      @circle ||= Circle.find(circle_id)
    end

  end
end
