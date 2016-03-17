ready = ->
  $('.show_all_comments').on 'click', showComments

showComments = ->
  elem = $('.task-comments')
  return if elem.hasClass('loading')
  elem.addClass 'loading'
  $.ajax(
    url: $('.show_all_comments a').data('url')
    success: (result) =>
      elem.removeClass 'loading'
      elem.html(result)
    error: (error, response)=>
      elem.removeClass('loading')
  )

$(document).on 'ready', ready
$(document).on 'page:load', ready
