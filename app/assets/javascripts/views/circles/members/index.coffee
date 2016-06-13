ready = ->
  $(".member-list").tablesorter()
  new Lale.TabNav('.members_list .tab-nav', '.members_list .tab')

$(document).on 'ready', ready
$(document).on 'page:load', ready
