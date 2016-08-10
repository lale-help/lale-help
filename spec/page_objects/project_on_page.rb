class ProjectOnPage < PageObject::Base

  attr_accessor :name, :description, :due_date, :location

  def create
    add_button.click
    project_button.click
    fill_form
    submit_button.click
  end

  def created?
    find('.project-dashboard .title', text: name)
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
    fill_in "Project name",  with: name
  end
end