ready = ->

  # organizers must be cached since the content of #project_organizer_id will be swapped
  organizers = $('#project_organizer_id').html()

  showOrganizers = ->
    $('#project_organizer_id').parent().hide()
    working_group = $('#project_working_group_id :selected').text()
    escaped_wg = working_group.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(organizers).filter("optgroup[label='#{escaped_wg}']").html()
    if options
      $('#project_organizer_id').html(options)
      $('#project_organizer_id').parent().show()
    else
      $('#project_organizer_id').empty()
      $('#project_organizer_id').parent().hide()

  if $('#project_working_group_id').length 
    showOrganizers()
  $('#project_working_group_id').on 'change', showOrganizers


$(document).on 'ready', ready
$(document).on 'page:load', ready
