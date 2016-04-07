ready = ->

  handleTabNavClick = (event) ->
    tab = $(event.target).closest('a').data('tab')
    showTab(tab)

  showTab = (name) ->
    # update look of nav
    $('.project .tab-nav a').removeClass('selected')
    $('.project .tab-nav a.' + name).addClass('selected')
    # toggle tabs
    $('.project .tab').hide()
    $(".project .tab." + name).show()

  init = ->
    showTab('info')
    $('.project .tab-nav a').on 'click', handleTabNavClick

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready