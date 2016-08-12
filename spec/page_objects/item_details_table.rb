class ItemDetailsTable < SitePrism::Section

  element :organizer, '.organizer .details'
  element :working_group, '.work-group .details'

end