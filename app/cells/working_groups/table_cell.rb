class WorkingGroups::TableCell < ::ViewModel

  # the first argument to the #cell call is "model" in here
  alias :working_groups :model
  
  def groups
    working_groups.map do |group|
      OpenStruct.new(
        link_with_name: link_to_group(group),
        admins: group_admins(group),
        actions: links_for(group)
      )
    end
  end

  def show
    render
  end

  def link_to_group(group)
    link_to(group.name, circle_working_group_path(group.circle, group))
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

  def create_working_group_path
    new_circle_working_group_path(working_groups.first.circle)
  end

  def links_for(group)
    if showing_active?
      [link_to_edit(group), link_to_deactivate(group)]
    else
      [link_to_edit(group), link_to_reactivate(group), link_to_delete(group)]
    end
  end

  def link_to_edit(group)
    link_to t('helpers.edit_no_model'), edit_circle_working_group_path(group.circle, group), class: 'button-primary'
  end

  def link_to_deactivate(group)
    options = { class: 'button' }
    if (group.tasks.incomplete.count + group.supplies.incomplete.count) > 0
      options[:onclick] = "alert(#{t('.cant_deactivate_group_with_items').to_json}); return false;"
    else
      # this will submit the form anyhow even if onclick returns false, so only add it when
      # the link really should be followed.
      options[:method] = :patch
    end
    link_to(t('helpers.deactivate'), circle_working_group_disable_path(group.circle, group), options)
  end

  def link_to_delete(group)
    options = { class: 'button', method: 'delete', data: { confirm: t('.confirm_delete') } }
    link_to t('helpers.delete'), circle_working_group_path(group.circle, group), options
  end

  def link_to_reactivate(group)
    options = { class: 'button', method: 'patch' }
    link_to t('helpers.reactivate'), circle_working_group_activate_path(group.circle, group), options
  end

  def group_admins(group)
    group.active_admins.map { |u| u.name }
  end

end
