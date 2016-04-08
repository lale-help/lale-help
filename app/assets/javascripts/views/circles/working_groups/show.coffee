ready = ->

  init = ->
    new Lale.TabNav('.working-group .tab-nav', '.working-group .tab')

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready