class Circle::Join < ::Form
  attribute :user,      :model,   primary: true
  attribute :circle_id, :integer
  attribute :location,  :string, default: proc { user.address.full_address }, required: false

  class Submit < ::Form::Submit

    def execute
      unless user_in_circle?
        add_to_circle(user)
        notify_circle_admins if circle.must_activate_users?
      end
      circle
    end

    def role
      Circle::Role.send('circle.volunteer')
    end

    private

    def add_to_circle(user)
      unless role.where(user: user, circle: circle).exists?
        status = circle.must_activate_users? ? :pending : :active
        role.create(user: user, circle: circle, status: status)
      end
      user.primary_circle = circle unless user.primary_circle_id.present?
      user.save!
    end

    def notify_circle_admins
      circle.admins.active.each do |admin|
        token = Token.login.create!(context: { user_id: admin.id })
        UserMailer.delay.account_activation(circle.id, admin.id, token.code)
      end
    end

    def circle
      @circle ||= Circle.find(circle_id)
    end

    def user_in_circle?
      user.circles.map(&:id).include?(circle_id)
    end

  end
end
