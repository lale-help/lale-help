@ifPage = (pages, func)->
  for page in $.makeArray(pages)
    if Lale.PageUtils.currentPage() == page
      func()
      break


@ifController = (controllers, func)->
  for controller in $.makeArray(controllers)
    if Lale.PageUtils.currentController() == controller
      func()
      break


@onPage = (page, func)->
  @onLoad (e)->
    ifPage page, ->
      func(e)

# Fire once on full page load
@onReady = (func)->
  $(document).on 'ready', func

# Fire on every page load
@onLoad = (func)->
  $(document).on 'ready page:load', func
