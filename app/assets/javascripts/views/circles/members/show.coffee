ready = ->
  $('button#show-organizer-info').on 'click', ->
    $('.organizer-info').fadeIn()

$(document).on 'ready', ready
$(document).on 'page:load', ready
