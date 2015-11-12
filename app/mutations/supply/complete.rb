class Supply::Complete < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    supply.complete = true

    add_error :complete, :failed unless supply.save

    supply
  end
end