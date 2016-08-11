class ProjectPage < PageObject::Base

  def has_name?(name)
    find('.project-dashboard .title', text: name)
  end

  def has_organizer?(organizer_name)
    # check correct organizer
    find(".item-details-table .details", text: "Organized by #{organizer_name}")
  end

  def has_working_group?(working_group_name)
    find(".item-details-table .work-group .details", text: working_group_name)
  end

end