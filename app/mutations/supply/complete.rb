class Supply::Complete < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    supply.complete = true


    if supply.save
      Task::Comments::Base.run(task: supply, message: 'completed', user: user)
    else
      add_error :complete, :failed
    end

    supply
  end
end
