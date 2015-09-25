$ ->
  $('.working-title-container').click (e) ->
    $(e.currentTarget).parent('article.working-group').toggleClass('working-group-open').toggleClass('working-group-closed')

  $('.task-header-container').click (e) ->
    return if $(e.target).hasClass('edit_link')
    $(e.currentTarget).parents('.working-task').toggleClass('task-expanded')
