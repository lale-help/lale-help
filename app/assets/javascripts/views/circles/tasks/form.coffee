# FIXME adapt to new UI
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

  # http://xdsoft.net/jqplugins/datetimepicker/
  $.datetimepicker.setLocale(I18n.locale);

  # FIXME pass config in data attributes
  $('.datepicker').datetimepicker({
    timepicker:     false,
    dayOfWeekStart: I18n.t('datepicker.day_of_week_start'),
    format:         I18n.t('datepicker.date_format')
  });

  # FIXME pass config in data attributes
  $('.timepicker').datetimepicker({
    datepicker:     false,
    step:           15,
    dayOfWeekStart: I18n.t('datepicker.day_of_week_start'),
    format:         I18n.t('datepicker.time_format'),
  });

  showOrHideEndDate = ->
    type = $('#task_scheduled_time_type').val()
    if type == "between" 
      $('.label-due').hide()
      $('.label-start-end').show()
      $('.end_date').show()
    else
      $('.label-due').show()
      $('.label-start-end').hide()
      $('.end_date').hide()

  # FIXME adapt to new UI
  validateTime = ->
    start = new Time($('#task_scheduled_time_start'))
    end   = new Time($('#task_scheduled_time_end'))
    end.update(start) if end.lessThan(start)

  if $("form.edit_task, form.new_task").length > 0
    showOrHideEndDate()
    $('#task_scheduled_time_type').on 'change', showOrHideEndDate

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
