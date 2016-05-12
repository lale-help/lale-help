ready = ->
  $('button#show-organizer-info').on 'click', (e)->
    $('button#show-organizer-info')
      .attr('disabled', 'disabled')
      .css('cursor', 'default')
      .removeClass('button-primary')
    $('.organizer-info').fadeIn()


$(document).on 'ready', ready
$(document).on 'page:load', ready
