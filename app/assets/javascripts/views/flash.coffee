class Lale.Flash
  @fadeOut: ->
    $('.flash-message').each (idx)->
      $(this).delay(500*idx).fadeOut(500)

  @add: (level, message)=>
    $('.flash').append(HandlebarsTemplates['flash'](level: level, message: message))
    @fadeOut()

  @info: (msg)=>
    @add('info', msg)

  @success: (msg)=>
    @add('success', msg)

  @warning: (msg)=>
    @add('warning', msg)

  @error: (msg)=>
    @add('error', msg)

  @default: (msg)=>
    @add('', msg)

$(document).on 'ready page:load', ->
  setTimeout(Lale.Flash.fadeOut, 3000)
