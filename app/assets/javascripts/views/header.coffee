ready = ->
  $('body').on 'click', (e)->
    unless $(e.target).parents('.dropdown').length > 0 || $(e.target).hasClass('dropdown')
      $('.menu-selector').prop('checked', false)



$(document).on 'ready', ready
$(document).on 'page:load', ready
