ready = ->
  $('body').on 'click', (e)->
    if $(e.target).parents('.circle-add-menu').length > 0
      $('.circle-add-menu').toggleClass('open')
    else
      $('.circle-add-menu').removeClass('open')


$(document).on 'ready', ready
$(document).on 'page:load', ready
