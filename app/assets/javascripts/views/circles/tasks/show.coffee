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

closeModalAndReloadPage = ->
  $(sourcingOptionsModalSelector).remodal().close()
  Turbolinks.visit(location.href)

assignVolunteer = (event)->
  event.preventDefault();
  form = $(this).closest('form')
  $.ajax
    url:     form.attr('action'),
    method:  form.attr('method'),
    data:    form.serialize(),
    success: closeModalAndReloadPage

inviteHelpers = (event)->
  event.preventDefault();
  container = $(this).closest('.invite-helpers')
  radioButton = container.find('input[type=radio]:checked')
  $.ajax
    url:     radioButton.data('url'),
    method:  container.data('method'),
    success: closeModalAndReloadPage

sourcingOptionsModalSelector = "[data-remodal-id=find-helpers]"

# listening on document so we don't need to init everything on DOM ready
$(document)
  .on('click', '.show_all_comments', showComments)
  .on('click', '#button-open-find-helpers', openSourcingOptionsModal)
  .on('click', '.assign-helpers .button', assignVolunteer)    
  .on('click', '.invite-helpers .button', inviteHelpers)    
  