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
  $('.datetimepicker').datetimepicker({
    step:           15,
    dayOfWeekStart: I18n.t('datepicker.day_of_week_start'),
    format:         I18n.t('datepicker.datetime_format'),
    minDate:        0,
  });

  $('.datetimepicker-toggle').on 'click', (e)->
    # FIXME simplify this mess
    selector = '#' + $(e.target).data('target')
    $(selector).datetimepicker('toggle')

  showOrHideEndDate = ->
    type = $('#task_scheduled_time_type').val()
    if type == "between" 
      $('.datetime2').show()
      $('.datetime1-default-label').hide()
      $('.datetime1-between-label').show()
    else
      $('.datetime2').hide()
      $('.datetime1-default-label').show()
      $('.datetime1-between-label').hide()

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
