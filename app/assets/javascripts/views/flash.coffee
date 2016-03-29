class Lale.Flash
  @fadeOut: (waitTime=2000)->
    if $('.flash-message').length > 0
      $('.flash-message').each (idx)->
        $(this).delay(waitTime + 500*idx).fadeOut 500, ->

  @add: (level, message, waitTime=2000)=>
    $('.flash').append(HandlebarsTemplates['flash'](level: level, message: message))
    @fadeOut(waitTime)

  @info: (msg)=>
    @add('info', msg)

  @success: (msg)=>
    @add('success', msg)

  @warning: (msg)=>
    @add('warning', msg)

  @error: (msg)=>
    @add('error', msg, 5000)

  @default: (msg)=>
    @add('', msg)

$(document).on 'ready page:load', ->
  waitTime = if ($('.flash-message.alert').length > 0) then 5000 else 2000
  Lale.Flash.fadeOut(waitTime)
