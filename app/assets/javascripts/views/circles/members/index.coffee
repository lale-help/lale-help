ready = ->
  $(".member-list").tablesorter()

$(document).on 'ready', ready
$(document).on 'page:load', ready
