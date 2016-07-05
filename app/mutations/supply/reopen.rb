class Supply::Reopen < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    supply.completed_at = nil


    if supply.save
      Comment::AutoComment.run(item: supply, message: 'reopened', user: user)
    else
      add_error :supply, :reopening_failed
    end

    supply
  end
end
