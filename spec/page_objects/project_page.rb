class ProjectPage < PageObject::Base

  # FIXME not used right now
  # attr_accessor :name, :description, :working_group_name, :organizer_name

  def has_values?(attributes)
    # check project name
    find('.project-dashboard .title', text: attributes[:name])
    # check correct organizer
    find(".item-details-table .details", text: "Organized by #{attributes[:organizer_name]}")
    # check correct working group
    find(".item-details-table .work-group .details", text: attributes[:working_group_name])
  end

end