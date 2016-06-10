showComments = ->
  elem = $('.task-comments')
  return if elem.hasClass('loading')
  elem.addClass 'loading'
  $.ajax
    url: elem.data('url')
    success: (result) =>
      elem.removeClass 'loading'
      elem.html(result)
    error: (error, response) =>
      elem.removeClass('loading')

openSourcingOptionsModal = -> 
  $(sourcingOptionsModalSelector).remodal().open();
  $('#new_volunteer_ids').select2(placeholder: "by name", language: I18n.locale)

assignVolunteer = (event)->
  event.preventDefault();
  form = $(this).closest('form')
  $.ajax
    url:  form.attr('action'),
    method: form.attr('method'),
    data: form.serialize(),
    success: (result) => 
      $(sourcingOptionsModalSelector).remodal().close()
      Turbolinks.visit(location.href)

sourcingOptionsModalSelector = "[data-remodal-id=find-helpers]"

# listening on document so we don't need to wait for DOM ready
$(document)
  .on('click', '.show_all_comments', showComments)
  .on('click', '#button-open-find-helpers', openSourcingOptionsModal)
  .on('click', '#submit-assign-volunteer', assignVolunteer)    
