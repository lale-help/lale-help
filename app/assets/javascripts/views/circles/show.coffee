ready = ->

  init = ->
    new Lale.StatusLink('.collection-dashboard .tab.tasks a.task_status', '.collection-dashboard .tab.tasks .task_section')
    new Lale.StatusLink('.collection-dashboard .tab.supplies a.task_status', '.collection-dashboard .tab.supplies .task_section')

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready
