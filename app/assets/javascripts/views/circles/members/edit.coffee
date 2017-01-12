setDateInputState = ->
  input_field_state = !$('#user_accredited').is(':checked')
  $('#user_accredited_until_string').prop('disabled', input_field_state)

ready = ->
  
  # using .xd_datepicker since active admin binds it's a jQuery UI datepicker
  # to all .datepicker classes, which causes two datepickers to appear.
  $('.xd_datepicker').datetimepicker({
    timepicker:     false,
    dayOfWeekStart: I18n.t('datepicker.day_of_week_start'),
    format:         I18n.t('datepicker.date_format'),
    minDate:        0,
    scrollMonth:    false
  });

  $('#user_profile_image').on 'change', -> 
    $('#user_remove_profile_image').prop('checked', false);

  setDateInputState()
  $('#user_accredited').on 'click', ->
    setDateInputState()
    
$(document).on 'ready', ready
$(document).on 'page:load', ready
