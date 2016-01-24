ready = ->
  $('#circle_role_role_type').on 'change', (e)->
    $type = $(e.target)
    $name = $type.siblings('#circle_role_name')
    console.log(e)
    console.log($type.val())
    if $type.val() == "circle.custom"
      $name.removeClass("hidden")
    else
      $name.addClass("hidden")
      $name.val("")

  $('#add-role a').on 'click', (e)->
    $('#add-role').addClass('hidden')
    $('#add-role-fields').removeClass('hidden')

  new Clipboard('button[type="copy"]');

$(document).on 'page:load ready', ready
