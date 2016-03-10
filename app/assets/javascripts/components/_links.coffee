$(document).on 'page:load ready', ->
  $("div[href]").on 'click', (e)->
    Turbolinks.visit $(e.currentTarget).attr('href')

  $("a.back").on 'click', (e)->
    if window.history && window.history.length > 2 # make sure we have browser history
      window.history.back()
      e.preventDefault()
      false