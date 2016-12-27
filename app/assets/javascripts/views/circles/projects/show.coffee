showComments = ->
  elem = $('.project-comments')
  return if elem.hasClass('loading')
  elem.addClass 'loading'
  $.ajax
    url: elem.data('url')
    success: (result) =>
      elem.removeClass 'loading'
      elem.html(result)
    error: (error, response) =>
      elem.removeClass('loading')

$(document)
  .on('click', '.show_all_comments', showComments)
