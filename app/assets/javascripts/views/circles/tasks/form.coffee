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


$(document).on 'ready', ready
$(document).on 'page:load', ready
