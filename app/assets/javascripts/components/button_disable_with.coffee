# jquery-ujs can disable buttons if they have an attribute data-disable-with
# this only works if the button is within a form and the form is submitted
# this snippet adds that feature to any button with that data attribute.
$(document).on('click', 'button[data-disable-with]', -> 
  $(this)
    .html($(this).data('disable-with'))
    .attr('disabled', 'disabled')
    .css('cursor', 'default')
)