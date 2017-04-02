class SupplyMailer < BaseMandrillMailer
  def supply_completion_reminder(task_id, user_id, token_code)
    task = Task.find(task_id)
    user = User.find(user_id)
    build_message(user.language, user.email) do
      merge_vars(user, task).merge({
        "SUPPLY_MARK_COMPLETE_URL" => handle_token_url(token_code, status: :completed),
        "SUPPLY_ADD_COMMENT_URL"   => handle_token_url(token_code)
      })
    end
  end


  def supply_invitation(supply_id, user_id, token_code)
    supply = Supply.find(supply_id)
    user = User.find(user_id)
    build_message(user.language, user.email) do
      merge_vars(user, supply).merge({
        "WORKGROUP"         => supply.working_group.name,
        "SUPPLY_URL"        => handle_token_url(token_code),
        "SUPPLY_ACCEPT_URL" => handle_token_url(token_code, status: :accept),
      })
    end
  end


  private

  def merge_vars user, supply
    {
      "FIRST_NAME"         => user.first_name,
      "SUPPLY_TITLE"       => supply.name,
      "SUPPLY_DESCRIPTION" => supply.description.truncate(100, separator: /\s/, omission: '...'),
      "SUPPLY_DUE_DATE"    => supply.due_date,
      "SUPPLY_LOCATION"    => supply.location.try(:address) || '',
    }
  end
end
