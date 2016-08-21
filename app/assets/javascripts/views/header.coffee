$(document).on('click', '.dropdown', (e)->
  unless $(e.target).parents('.dropdown').length > 0 || $(e.target).hasClass('dropdown')
    $('.menu-selector').prop('checked', false)
)

# toggle sidebar (main navigation) visibility with a "burger menu"
$(document).on('click', '.nav-toggle', ->
  $('.nav-toggle').toggleClass('clicked')
  $('#sidebar').toggleClass('full-width')
)
