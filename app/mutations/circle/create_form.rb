class Circle::CreateForm < Circle::BaseForm
  class Submit < Circle::BaseForm::Submit
    def execute
      super

      Circle::Role.send('circle.admin').create(circle: circle, user: user, status: :active)
      Circle::Role.send('circle.volunteer').create(circle: circle, user: user, status: :active)

      user.update_attribute :primary_circle, circle
      
      circle
    end
  end
end