class ProjectOnPage < PageObject::Base

  attr_accessor :name, :description, :working_group_name, :organizer_name

  def create
    add_button.click
    project_button.click
    fill_form
    submit_button.click
  end

  def created?
    # check project name
    find('.project-dashboard .title', text: name)
    # check correct organizer
    find(".item-details-table .details", text: "Organized by #{organizer_name}")
    # check correct working group
    find(".item-details-table .details", text: working_group_name)
  end

  def invalid?
    find('p', text: 'Please correct the errors below.')
  end

  def has_validation_error?(string)
    find('span.error_description', text: string)
  end

  private

  def add_button
    find('.button-super', text: /Add/)
  end

  def project_button
    find('.menu a', text: /Project/)
  end

  def submit_button
    find('input[type=submit][value="Create Project"]')
  end

  def fill_form
    fill_in "Project name", with: name
    if working_group_name
      find("#project_working_group_id").select(working_group_name)
    end
    if organizer_name
      find("#project_organizer_id").select(organizer_name)
    end
  end
end