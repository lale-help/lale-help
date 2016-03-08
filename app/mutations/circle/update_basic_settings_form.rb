class Circle::UpdateBasicSettingsForm < Circle::BaseForm

  def redirect_path
    circle_admin_path(circle)
  end

  def view_for_error
    'circle/admins/show'
  end

  class Submit < Circle::BaseForm::Submit

    def execute
      circle.assign_attributes inputs.slice(:name)
      circle.language = Circle.languages[language]
      circle.address.assign_attributes inputs.slice(:street_address_1, :city, :state_province, :postal_code, :country)

      circle.save

      circle
    end

  end
end