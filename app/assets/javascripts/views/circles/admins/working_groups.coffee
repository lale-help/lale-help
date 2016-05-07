$.rails.allowAction = (link) ->
  if !link.attr('data-confirm')
    return true
  $.rails.showConfirmDialog link
  false

$.rails.confirmed = (link) ->
  link.removeAttr 'data-confirm'
  link.trigger 'click.rails'

$.rails.showConfirmDialog = (link) ->
  confirm = $.parseJSON(link.attr('data-confirm'))
  working_group = confirm.working_group
  data = $.extend({}, I18n.t('confirm.defaults'), confirm.type)
  data.showCancelButton = true
  data.confirmButtonColor = '#DD6B55'
  data.closeOnConfirm = false
  data.closeOnCancel = false
  data.type = 'input'

  swal data, (inputValue) ->
    if inputValue == working_group
      swal data.completed, data.delete_confirmed, 'success',
        $.rails.confirmed(link)
    else
      swal I18n.t('circle.admins.working_groups.delete_pop_up.cancelled'), I18n.t('circle.admins.working_groups.delete_pop_up.cancel_confirmed', 'working_group': working_group), 'error'
    return
