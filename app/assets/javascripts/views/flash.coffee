class Lale.Flash
  @fadeOut: (waitTime=2000)->
    if $('.flash-message').length > 0
      $('.flash-message').each (idx)->
        $(this).delay(waitTime + 500*idx).fadeOut 500, ->

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
  Lale.Flash.fadeOut()
