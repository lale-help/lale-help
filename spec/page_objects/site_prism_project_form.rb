class SPProjectForm < SitePrism::Page

  set_url '/circles/{circle_id}/projects/new?as={as_id}'

  element :name, "#project_name"
  element :working_group, "#project_working_group_id"
  element :organizer, "#project_organizer_id"
  element :submit_button, ".submit-row input[type=submit]"

  # FIXME DRY up
  def invalid?
    find('p', text: 'Please correct the errors below.')  
  end

  # FIXME DRY up
  def has_validation_error?(string)
    find('span.error_description', text: string)
  end

  # FIXME DRY up
  def submit_with(attributes)
    fill_form(attributes)
    submit_button.click
    next_page_object # on success, return the next page object
  end

  # FIXME DRY up
  def next_page_object
    SPProjectPage.new
  end

  # FIXME DRY up
  def fill_form(attributes)
    name.set(attributes[:name])
    if attributes[:working_group_name]
      working_group.select(attributes[:working_group_name])
    end
    if attributes[:organizer_name]
      organizer.select(attributes[:organizer_name])
    end
  end
end