class Time
  constructor: (@selector)->
    @str = @selector.val()
    parts = @str.split(":")
    @hour   = parseInt(parts[0])
    @minute = parseInt(parts[1])

  lessThan: (other) ->
    if @hour < other.hour
      true

    else if @hour == other.hour
      @minute <= other.minute

    else
      false

  update: (other) ->
    @selector.val(other.str)

ready = ->
  showOrHideTime = ->
    type = $('#task_scheduled_time_type').val()
    if type == "at"
      $('.scheduled-time').show()
      $('.scheduled-time .start').show()
      $('.scheduled-time .end').hide()

    else if type == "between"
      $('.scheduled-time').show()
      $('.scheduled-time .start').show()
      $('.scheduled-time .end').show()

    else
      $('.scheduled-time').hide()
      $('.scheduled-time .start').hide()
      $('.scheduled-time .end').hide()

  validateTime = ->
    start = new Time($('#task_scheduled_time_start'))
    end   = new Time($('#task_scheduled_time_end'))
    end.update(start) if end.lessThan(start)

  if $("form.edit_task, form.new_task").length > 0
    showOrHideTime()
    $('#task_scheduled_time_type').on 'change', showOrHideTime

    validateTime()
    $('#task_scheduled_time_start, #task_scheduled_time_end').on 'change', validateTime

  organizers = $('#task_organizer_id').html()
  showOrganizers = ->
    $('#task_organizer_id').parent().hide()
    working_group = $('#task_working_group_id :selected').text()
    escaped_wg = working_group.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(organizers).filter("optgroup[label='#{escaped_wg}']").html()
    console.log options
    if options
      $('#task_organizer_id').html(options)
      $('#task_organizer_id').parent().show()
    else
      $('#task_organizer_id').empty()
      $('#task_organizer_id').parent().hide()

  showOrganizers()
  $('#task_working_group_id').on 'change', showOrganizers

$(document).on 'ready', ready
$(document).on 'page:load', ready
