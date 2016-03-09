$(document).on 'page:load ready', ->

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

  clipboard = new Clipboard('button[type="copy"]')
  clipboard.on 'success', (e)->
      e.clearSelection()
      Lale.Flash.info I18n.t('workflow.copied')

  $('.activate_pending_user').closest('form')
    .on 'ajax:success', (event)->
      $(event.target.closest('tr')).fadeOut 'duration': 1000, complete: ->
        # FIXME add id to admin link
        # FIXME also update dot in 2nd level nav
        badge = $('#admin_link').children('span.badge')
        task_count = parseInt(badge.text())        
        if (task_count == 1)
          badge.hide()
        else
          badge.text(task_count - 1)
        Lale.Flash.info I18n.t('workflow.activation_success')
    .on 'ajax:error', (event)->
      Lale.Flash.error I18n.t('workflow.activation_error') 