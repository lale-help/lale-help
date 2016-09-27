module FormHelper

  def skill_select(tag_name:, tag_id:, selected_skill: nil)
    content_tag('select', name: tag_name, id: tag_id, multiple: true) do
      concat(content_tag('option', I18n.t('circle.tasks.form.project_blank'), value: ""))
      Skill.all.group_by(&:category).each do |category, skills|
        concat(content_tag('optgroup', label: category) do
          skills.each do |skill|
            skill_name = I18n.t("skills.#{category}.#{skill.key}")
            options = {
              value: skill.id,
              selected: (skill.id == selected_skill.try(:id)),
              'title': "#{category}: #{skill_name}"
            }
            concat(content_tag('option', skill_name, options))
          end
        end)
      end
    end
  end

end
