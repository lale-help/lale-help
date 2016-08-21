# jquery-ujs can disable buttons if they have an attribute data-disable-with.
# This only works though if the button is within a form and the form is submitted
# this snippet adds that feature to any button with that data attribute.
#
# only run this if we're not on a submit tag. because then 
# the rails-ujs stuff will run, causing 2 scripts to execute
$(document).on('click', '[data-disable-on-click]', ->  
  $(this)
    # this for disabling if it's a button
    .attr('disabled', 'disabled')
    # this for disabling if it's a link
    .removeAttr('href')
    # cursor
    .css({cursor: 'progress'})
)