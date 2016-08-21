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
  $(sourcingOptionsModalSelector).remodal().open()
  # init assign form
  el = $('#new_volunteer_ids')
  el.select2(placeholder: el.attr('placeholder'), language: I18n.locale)
  # init assign button state
  $('#new_volunteer_ids').trigger('change')
  # init invite button state
  $('.invite-helpers input[type=radio][checked=checked]').trigger('change')
  
# button should not be clickable when no volunteer selected
updateAssignButtonState = ->
  button   = $(this).closest('form').find('button')
  disabled = !$('#new_volunteer_ids').val()
  button.attr('disabled', disabled)

# button should not be clickable when no one would be invited
updateInviteButtonState = ->
  button   = $(this).closest('.invite-helpers').find('button')
  disabled = parseInt($(this).data('invitees-count')) == 0
  button.attr('disabled', disabled)

closeModalAndReloadPage = ->
  $(sourcingOptionsModalSelector).remodal().close()
  Turbolinks.visit(location.href)

assignVolunteer = (event)->
  event.preventDefault();
  if $('#new_volunteer_ids').val()
    form = $(this).closest('form')
    $.ajax
      url:     form.attr('action'),
      method:  form.attr('method'),
      data:    form.serialize(),
      success: closeModalAndReloadPage

unassignVolunteer = (event)->
  event.preventDefault();
  badge = $(this).closest('.user-badge')
  $.ajax
    url:     badge.data('unassign-action'),
    method:  badge.data('unassign-method')
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
  .on('change', '#new_volunteer_ids', updateAssignButtonState)
  .on('change', '.invite-helpers input[type=radio]', updateInviteButtonState)
  .on('click', '.invite-helpers .button', inviteHelpers)    
  .on('click', '.users-box .unassign-user-icon', unassignVolunteer)    
  