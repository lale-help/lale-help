$(document).on 'page:load ready', ->
  $("div[href]").on 'click', (e)->
    Turbolinks.visit $(e.currentTarget).attr('href')
