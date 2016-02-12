class SupplyMailer < BaseMandrillMailer
  def supply_completion_reminder(task, user, token)
    build_message(user.language, user.email) do
      merge_vars(user, task).merge({
        "TASK_MARK_COMPLETE_URL" => handle_token_url(token.code, status: :completed),
        "TASK_ADD_COMMENT_URL"   => handle_token_url(token.code)
      })
    end
  end


  def supply_invitation(supply, user, token)
    build_message(user.language, user.email) do
      merge_vars(user, supply).merge({
        "WORKGROUP"         => supply.working_group.name,
        "SUPPLY_URL"        => handle_token_url(token.code),
        "SUPPLY_ACCEPT_URL" => handle_token_url(token.code, status: :accept),
      })
    end
  end


  def supply_comment(task, comment, user)
    # TODO: actually send message
    # build_message(user.language, user.email) do
    #   merge_vars(user, task).merge({
    #     "TASK_COMMENT"    => comment.body,
    #     "TASK_REVIEW_URL" => handle_token_url(user.login_token.code, redirect: circle_task_path(task.circle, task)),
    #   })
    # end
  end


  private

  def merge_vars user, supply
    {
      "FIRST_NAME"         => user.first_name,
      "SUPPLY_TITLE"       => supply.name,
      "SUPPLY_DESCRIPTION" => supply.description.truncate(100, separator: /\s/, omission: '...'),
      "SUPPLY_DUE_DATE"    => supply.due_date,
      "SUPPLY_LOCATION"    => supply.location.address,
    }
  end
end