class Supply::Destroy < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    supply.destroy
  end
end