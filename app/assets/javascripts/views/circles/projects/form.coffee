ready = ->
  new Lale.WorkgroupDependentSelect('#project_working_group_id', '#project_organizer_id')

$(document).on 'ready', ready
$(document).on 'page:load', ready