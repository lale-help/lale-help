ready = ->

  init = ->
    # FIXME init TabNav globally
    new Lale.TabNav('.tab-nav', '.tab')
    new Lale.StatusLink('.working-group .tab.tasks a.task_status', '.working-group .tab.tasks .task_section')
    new Lale.StatusLink('.working-group .tab.supplies a.task_status', '.working-group .tab.supplies .task_section')

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready
