ready = ->

  #
  # methods first
  #

  init = ->
    new Lale.WorkgroupDependentSelect('#supply_working_group_id', '#supply_project_id', {hideOnEmpty: true})
    new Lale.WorkgroupDependentSelect('#supply_working_group_id', '#supply_organizer_id')

  #
  # then init
  #
  init()
  

$(document).on 'ready', ready
$(document).on 'page:load', ready
