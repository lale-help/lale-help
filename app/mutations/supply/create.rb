class Supply::Create < Supply::BaseForm

  def working_group_disabled?
    super || ! @working_group_id.nil?
  end

  class Submit < Supply::BaseForm::Submit
  end

end
