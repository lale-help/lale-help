class Lale.DateTime
  constructor: (date_field, time_field)->
    @value = this.buildDate(date_field, time_field)

  buildDate: (date_field, time_field)->
    date = this.parseDate(date_field)
    time = this.parseTime(time_field)
    date.setHours(time['hours'])
    date.setMinutes(time['minutes'])
    date

  valid:->
    @value instanceof Date

  parseDate: (field)->
    field.datetimepicker('getValue')

  parseTime: (field)->
    if field.val()
      parts = field.val().split(":")
      h = parseInt(parts[0])
      m = parseInt(parts[1])
    else
      h = 0
      m = 0
    { hours: h, minutes: m }

ready = ->

  initTimeDatePickers = ->
    # http://xdsoft.net/jqplugins/datetimepicker/
    $.datetimepicker.setLocale(I18n.locale);

    # using .xd_datepicker since active admin binds it's a jQuery UI datepicker
    # to all .datepicker classes, which causes two datepickers to appear.
    $('.xd_datepicker').datetimepicker({
      timepicker:     false,
      dayOfWeekStart: I18n.t('datepicker.day_of_week_start'),
      format:         I18n.t('datepicker.date_format'),
      minDate:        0,
      scrollMonth:    false,
      onChangeDateTime: validateDateTime
    });

    $('.xd_timepicker').datetimepicker({
      datepicker:     false,
      step:           15,
      format:         I18n.t('datepicker.time_format'),
      defaultTime:    '12:00',
      onChangeDateTime: validateDateTime
    });

  showOrHideStartDate = ->
    type = $('#task_scheduling_type').val()
    if type == "between" 
      $('.at-element').hide()
      $('.between-element').show()
    else
      $('.at-element').show()
      $('.between-element').hide()

  validateDateTime = ->
    start = new Lale.DateTime($('#task_start_date_string'), $('#task_start_time'))
    due   = new Lale.DateTime($('#task_due_date_string'), $('#task_due_time'))

    # when start date is before due date, set them both to start date
    if start.valid() && due.valid() && (start.value > due.value)
      console.log $('#task_due_date_string').val()
      console.log $('#task_start_date_string').val()
      $('#task_due_date_string').val($('#task_start_date_string').val())
      $('#task_due_time').val($('#task_start_time').val())


  if $("form.edit_task, form.new_task").length > 0
    showOrHideStartDate()
    $('#task_scheduling_type').on 'change', showOrHideStartDate
    initTimeDatePickers()

  organizers = $('#task_organizer_id').html()
  showOrganizers = ->
    $('#task_organizer_id').parent().hide()
    working_group = $('#task_working_group_id :selected').text()
    escaped_wg = working_group.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(organizers).filter("optgroup[label='#{escaped_wg}']").html()
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
