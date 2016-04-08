ready = ->

  handleTabNavClick = (event) ->
    name = $(event.target).closest('a').data('tab')
    showTab(name)

  showTab = (name) ->
    # update look of nav
    $('.project-page .tab-nav a').removeClass('selected').filter("." + name).addClass('selected')
    # toggle tabs
    $('.project-page .tab').hide().filter("." + name).show()

  handleMemberBoxClick = (event) ->
    el = $(event.target).closest('.members')
    if (el.data('moved') != true)
      el.animate({left: "-=150"})
      el.data('moved', true)
    else
      el.animate({left: "+=150"})

  init = ->
    showTab('info')
    $('.project-page .tab-nav a').on 'click', handleTabNavClick
    # WIP
    # $('.project-page .members .title').on 'click', handleMemberBoxClick

  init()

$(document).on 'ready', ready
$(document).on 'page:load', ready