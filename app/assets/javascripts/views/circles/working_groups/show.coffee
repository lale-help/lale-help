ready = ->

  init = ->
    new Lale.TabNav('.working-group .tab-nav', '.working-group .tab')
    new Lale.StatusLink('.working-group .tab.tasks a.task_status', '.working-group .tab.tasks .task_section')
    new Lale.StatusLink('.working-group .tab.supplies a.task_status', '.working-group .tab.supplies .task_section')

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready
