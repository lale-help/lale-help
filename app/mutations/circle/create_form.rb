class Circle::CreateForm < Circle::BaseForm
  class Submit < Circle::BaseForm::Submit
    def execute
      super

      Circle::Role.send('circle.admin').create(circle: circle, user: user, status: :active)
      Circle::Role.send('circle.volunteer').create(circle: circle, user: user, status: :active)

      user.update_attribute :primary_circle, circle

      circle
    rescue ActiveRecord::RecordNotUnique => e
      handle_record_not_unique_exception(e)
    end
  end
end
