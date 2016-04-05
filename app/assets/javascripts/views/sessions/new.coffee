$(document).on 'page:load ready', ->
  # will only fade in if the element is in the DOM,
  # which is controller server-side.
  $('.new_form .login_error').fadeIn('slow')
  $('#login_form #email').focus()