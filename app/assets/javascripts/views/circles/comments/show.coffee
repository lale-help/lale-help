ready = ->
  $('.show_all_comments').on 'click', showComments
  bindEditEvents()

showComments = ->
  elem = $('.task-comments')
  return if elem.hasClass('loading')
  elem.addClass 'loading'
  $.ajax(
    url: elem.data('url')
    success: (result) =>
      elem.removeClass 'loading'
      elem.html(result)
      bindEditEvents()
    error: (error, response)=>
      elem.removeClass('loading')
  )

bindEditEvents = ->
  $('.edit_comment_link').on 'click', editCommentModeOn
  $('.cancel_edit_comment').on 'click', resetEditComment
  $('.edit-comment form').on 'submit', editCommentSubmit

editCommentModeOn = (e) ->
  main = $(e.currentTarget).parents('.comment-main')
  main.find('.body .comment-text').toggleClass('inactive')
  main.find('.body .edit-comment').toggleClass('inactive')
  main.find('.actions').toggleClass('inactive')

editCommentModeOff = (e) ->
  main = $(e.currentTarget).parents('.comment-main')
  main.find('.body .comment-text').toggleClass('inactive')
  main.find('.body .edit-comment').toggleClass('inactive')
  main.find('.actions').toggleClass('inactive')

editCommentSubmit = (e) ->
  form = $(e.currentTarget)
  main = form.parents('.comment-main')
  body = form.find('#comment_body')
  $.ajax(
    url:      form.attr('action')
    method:   'PUT'
    dataType: 'json'
    data:     { comment: { body: body.val() } }
    success: (result) =>
      main.find('.body .comment-text').text(body.val())
      form.find('textarea').removeClass('error')
      editCommentModeOff(e)
    error: (error, response)=>
      body.addClass('error')
  )
  e.preventDefault()
  return false

resetEditComment = (e) ->
  main = $(e.currentTarget).parents('.comment-main')
  main.find('#comment_body').val(main.find('.body .comment-text').text())
  editCommentModeOff(e)

$(document).on 'ready', ready
$(document).on 'page:load', ready
