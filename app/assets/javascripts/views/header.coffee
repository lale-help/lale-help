ready = ->
  $('body').on 'click', (e)->
    console.log(e.target)
    if $(e.target).parents('.circle-add-menu').length > 0 || $(e.target).hasClass('circle-add-menu')
      $('.circle-add-menu').toggleClass('open')
    else
      $('.circle-add-menu').removeClass('open')


$(document).on 'ready', ready
$(document).on 'page:load', ready
