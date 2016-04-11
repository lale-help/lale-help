$.rails.allowAction = (link) ->
  if !link.attr('data-confirm')
    return true
  $.rails.showConfirmDialog link
  false

$.rails.confirmed = (link) ->
  link.removeAttr 'data-confirm'
  link.trigger 'click.rails'

$.rails.showConfirmDialog = (link) ->
  working_group = link.attr('data-confirm')
  swal {
    title: I18n.t('circle.admins.working_groups.delete_pop_up.title', 'working_group': working_group)
    text: I18n.t('circle.admins.working_groups.delete_pop_up.warning')
    type: 'input'
    showCancelButton: true
    confirmButtonColor: '#DD6B55'
    confirmButtonText: I18n.t('circle.admins.working_groups.delete_pop_up.delete')
    cancelButtonText: I18n.t('circle.admins.working_groups.delete_pop_up.cancel')
    closeOnConfirm: false
    closeOnCancel: false
  }, (inputValue) ->
    if inputValue == working_group
      swal I18n.t('circle.admins.working_groups.delete_pop_up.deleted'), I18n.t('circle.admins.working_groups.delete_pop_up.delete_confirmed', 'working_group': working_group), 'success', (inputValue) ->
        $.rails.confirmed(link)
    else
      swal I18n.t('circle.admins.working_groups.delete_pop_up.cancelled'), I18n.t('circle.admins.working_groups.delete_pop_up.cancel_confirmed', 'working_group': working_group), 'error'
    return
