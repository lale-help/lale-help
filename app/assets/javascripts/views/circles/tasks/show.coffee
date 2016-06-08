ready = ->
  $('.show_all_comments').on 'click', showComments

  $('#assign_volunteer_id').select2()
  $('#assign_volunteer_id').on 'change', assignVolunteer

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

assignVolunteer = ->
  userId = $(this).val()
  form = $(this).closest('form')
  if userId != ""
    $.ajax({
      url:  $(form).attr('action'),
      method: $(form).attr('method'),
      data: $(form).serialize()
    })



$(document).on 'ready', ready
$(document).on 'page:load', ready
