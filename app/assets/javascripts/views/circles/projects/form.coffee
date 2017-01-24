class Lale.Date
  constructor: (date_field)->
    # after init, the input element is still empty,
    # but the datepicker getValue call can already return a valid date object
    @dateFilled = date_field.val() != ''
    @value = this.buildDate(date_field)

  buildDate: (date_field)->
    date = this.parseDate(date_field)
    if !date then null else date

  valid:->
    # took out `&& (@value instanceof Date)` because it was always returning false
    @dateFilled

  parseDate: (field)->
    field.datetimepicker('getValue')

ready = ->

  initDatePickers = ->
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

  validateDateTime = ->
    start = new Lale.Date($('#project_start_date_string'))
    due   = new Lale.Date($('#project_due_date_string'))

    # when start date is after due date, set them both to start date
    if start.valid() && due.valid() && (start.value > due.value)
      $('#project_due_date_string').val($('#project_start_date_string').val())

  init = ->
    initDatePickers()

    new Lale.WorkgroupDependentSelect('#project_working_group_id', '#project_organizer_id', {hideOnEmpty: false})

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready
