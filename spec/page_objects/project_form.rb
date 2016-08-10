class ProjectForm < PageObject::Base

  attr_accessor :name, :description, :working_group_name, :organizer_name

  # FIXME remove duplication with ProjectOnPage
  def submit_with(attributes)
    self.attributes = attributes
    fill_form
    submit_button.click
  end

  def invalid?
    find('p', text: 'Please correct the errors below.')
  end

  def has_validation_error?(string)
    find('span.error_description', text: string)
  end

  private

  def fill_form
    fill_in "Project name", with: name
    if working_group_name
      find("#project_working_group_id").select(working_group_name)
    end
    if organizer_name
      find("#project_organizer_id").select(organizer_name)
    end
  end

  def submit_button
    find('input[type=submit][value="Update Project"]')
  end

end