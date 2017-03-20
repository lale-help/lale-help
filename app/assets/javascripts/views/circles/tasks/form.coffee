class Lale.DateTime
  constructor: (date_field, time_field)->
    # after init, the input element is still empty,
    # but the datepicker getValue call can already return a valid date object
    @dateFilled = date_field.val() != ''
    @value = this.buildDate(date_field, time_field)

  buildDate: (date_field, time_field)->
    date = this.parseDate(date_field)
    if date
      time = this.parseTime(time_field)
      date.setHours(time['hours'])
      date.setMinutes(time['minutes'])
      date
    else
      null

  valid:->
    @dateFilled && (@value instanceof Date)

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

  #
  # methods first
  #

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

    # when start date is after due date, set them both to start date
    if start.valid() && due.valid() && (start.value > due.value)
      $('#task_due_date_string').val($('#task_start_date_string').val())
      $('#task_due_time').val($('#task_start_time').val())

  init = ->
    if $("form.edit_task, form.new_task").length > 0
      showOrHideStartDate()
      $('#task_scheduling_type').on 'change', showOrHideStartDate
      initTimeDatePickers()

    new Lale.WorkgroupDependentSelect('#task_working_group_id', '#task_project_id', {hideOnEmpty: true})
    new Lale.WorkgroupDependentSelect('#task_working_group_id', '#task_organizer_id')

  #
  # then init
  #
  init()


$(document).on 'ready', ready
$(document).on 'page:load', ready
