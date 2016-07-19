# jquery-ujs can disable buttons if they have an attribute data-disable-with
# this only works if the button is within a form and the form is submitted
# this snippet adds that feature to any button with that data attribute.
$(document).on('click', '[data-disable-with]', ->
  # only run this if we're not in a form. otherwise the rails-ujs stuff should run.
  notInAForm = ($(this).parent('form').length == 0)
  if (notInAForm)
    $(this)
      .html($(this).data('disable-with'))
      # this for disabling if it's a button
      .attr('disabled', 'disabled')
      # this for disabling if it's a link
      .removeAttr('href')
)