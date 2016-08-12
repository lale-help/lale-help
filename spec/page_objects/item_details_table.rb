# FIXME consider moving this to a sections/components subdirectory.
class ItemDetailsTable < SitePrism::Section

  element :organizer, '.organizer .details'
  element :working_group, '.work-group .details'

end