class Circle::UpdateForm < Circle::BaseForm
  class Submit < Circle::BaseForm::Submit
    def execute
      super
      circle.assign_attributes inputs.slice(:name)
      circle.language = Circle.languages[language]
      circle.address.assign_attributes inputs.slice(:street_address_1, :city, :state_province, :postal_code, :country)

      circle.save

      circle
    end

  end
end