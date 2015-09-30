module TaskHelper
  def working_group_options circle
    circle.working_groups.map{ |w| [w.name, w.id] }
  end
end
