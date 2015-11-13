ready = ->
  $('body').on 'click', (e)->
    if $(e.target).parents('.dropdown').length > 0
      $(e.target).parents('.dropdown').toggleClass('open')

    else if $(e.target).hasClass('dropdown')
      $(e.target).toggleClass('open')

    else
      $('.dropdown').removeClass('open')



$(document).on 'ready', ready
$(document).on 'page:load', ready
