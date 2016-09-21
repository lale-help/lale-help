module FormHelper

  def taskable_project_select(projects_hash, selected_project:, tag_name:, tag_id:)
    content_tag('select', name: tag_name, id: tag_id) do
      concat(content_tag('option', I18n.t('circle.tasks.form.project_blank'), value: ""))
      projects_hash.each do |working_group, projects|
        concat(content_tag('optgroup', label: working_group.name) do
          projects.each do |project|
            options = { value: project.id, selected: (project.id == selected_project.try(:id)) }
            concat(content_tag('option', project.name, options))
          end
        end)
      end
    end
  end

end
