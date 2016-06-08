ready = ->
  $('.show_all_comments').on 'click', showComments
  $('#assigned_volunteer_id').select2();
  
showComments = ->
  elem = $('.task-comments')
  return if elem.hasClass('loading')
  elem.addClass 'loading'
  $.ajax(
    url: elem.data('url')
    success: (result) =>
      elem.removeClass 'loading'
      elem.html(result)
    error: (error, response)=>
      elem.removeClass('loading')
  )

$(document).on 'ready', ready
$(document).on 'page:load', ready
