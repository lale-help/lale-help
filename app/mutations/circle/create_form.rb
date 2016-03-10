class Circle::CreateForm < Circle::BaseForm
  class Submit < Circle::BaseForm::Submit
    def execute
      super

      Circle::Role.send('circle.admin').create(circle: circle, user: user)
      Circle::Role.send('circle.volunteer').create(circle: circle, user: user)

      user.update_attribute :primary_circle, circle
      user.active!
      
      circle
    end
  end
end