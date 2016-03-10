class Lale.Flash
  @fadeOut: (waitTime=2000)->
    if $('.flash-message').length > 0
      $('.flash-message').each (idx)->
        $(this).delay(waitTime + 500*idx).fadeOut 500, ->

  @add: (level, message, waitTime=2000)=>
    console.log("add")
    console.log(waitTime)
    $('.flash').append(HandlebarsTemplates['flash'](level: level, message: message))
    @fadeOut(waitTime)

  @info: (msg)=>
    console.log("info")
    @add('info', msg)

  @success: (msg)=>
    console.log("succ")
    @add('success', msg)

  @warning: (msg)=>
    console.log("warn")
    @add('warning', msg)

  @error: (msg)=>
    console.log("err")
    @add('error', msg, 5000)

  @default: (msg)=>
    console.log("defa")
    @add('', msg)

$(document).on 'ready page:load', ->
  waitTime = if ($('.flash-message.alert').length > 0) then 5000 else 2000
  Lale.Flash.fadeOut(waitTime)
