class WorkingGroup::ChangeStatus < Mutations::Command

  required do
    model :working_group
    string :status
  end

  def execute
    working_group.update_attribute(:status, WorkingGroup.statuses[status])
  end

end
