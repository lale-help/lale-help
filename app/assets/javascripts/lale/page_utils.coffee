class Lale.PageUtils
  @currentAction = ->
    $(document.body).data('action')

  @currentController = ->
    $(document.body).data('controller')

  @currentPage = =>
    "#{@currentController()}##{@currentAction()}"
