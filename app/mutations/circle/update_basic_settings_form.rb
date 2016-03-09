class Circle::UpdateBasicSettingsForm < Circle::BaseForm

  def redirect_path
    circle_admin_path(circle)
  end

  def view_for_error
    'circle/admins/show'
  end

  class Submit < Circle::BaseForm::Submit

    def execute
      super
    end

  end
end