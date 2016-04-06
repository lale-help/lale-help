class Supply::Reopen < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    supply.completed_at = nil

    add_error :supply, :reopening_failed unless supply.save

    supply
  end
end
