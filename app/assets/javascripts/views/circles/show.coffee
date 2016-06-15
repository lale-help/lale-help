ready = ->

  init = ->
    # FIXME make global
    new Lale.TabNav('.tab-nav', '.tab')
    new Lale.StatusLink('.circle-dashboard .tab.tasks a.task_status', '.circle-dashboard .tab.tasks .task_section')
    new Lale.StatusLink('.circle-dashboard .tab.supplies a.task_status', '.circle-dashboard .tab.supplies .task_section')

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready
