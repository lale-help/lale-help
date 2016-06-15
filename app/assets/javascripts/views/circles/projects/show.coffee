ready = ->

  init = ->
    # FIXME init TabNav globally
    new Lale.TabNav('.tab-nav', '.tab')

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready