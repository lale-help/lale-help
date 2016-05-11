class WorkingGroups::TableCell < ::ViewModel

  def groups
    # cells refers to the first argument in the cell() call as model
    model.map do |group|
      OpenStruct.new(
        name: group.name,
        admins: group_admins(group),
        actions: links_for(group)
      )
    end
  end

  def show
    render
  end

  def showing_active?
    @options[:status] == :active
  end

  def title
    t(".title_#{@options[:status]}")
  end

  def no_groups_message
    t('.no_groups')
  end

  def links_for(group)
    if showing_active?
      [link_to_edit(group), link_to_disable(group)]
    else
      [link_to_edit(group), link_to_delete(group), link_to_reactivate(group)]
    end
  end

  def link_to_edit(group)
    link_to t('.edit'), edit_circle_working_group_path(group.circle, group), class: 'button-primary'
  end

  def link_to_disable(group)
    options = { class: 'button', method: 'patch' }
    if (group.tasks.incomplete.count + group.supplies.incomplete.count) > 0
      options[:onclick] = "alert(#{t('.cant_delete_group_with_items').to_json}); return false;"
    end
    link_to t('.disable'), circle_working_group_disable_path(group.circle, group), options
  end

  def link_to_delete(group)
    options = { class: 'button', method: 'delete', data: { confirm: t('.confirm_delete') } }
    link_to t('.delete'), circle_working_group_path(group.circle, group), options
  end

  def link_to_reactivate(group)
    options = { class: 'button', method: 'patch' }
    link_to t('.reactivate'), circle_working_group_activate_path(group.circle, group), options
  end

  def group_admins(group)
    group.admins.active.map { |u| u.name }
  end

end
