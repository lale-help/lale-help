$(document).on('click', '.dropdown', (e)->
  unless $(e.target).parents('.dropdown').length > 0 || $(e.target).hasClass('dropdown')
    $('.menu-selector').prop('checked', false)
)