module LinksHelper

  def link_to_user(user)
    href = circle_member_path(user.primary_circle, user)
    link_to(html_escape(user.name), href)
  end
  
  def link_to_working_group(wg)
    href = circle_working_group_path(wg.circle, wg)
    link_to(html_escape(wg.name), href)
  end

  def link_to_circle(circle)
    href = circle_path(circle)
    link_to(html_escape(circle.name), href)
  end

  def link_to_project(project)
    href = circle_project_path(project.circle, project)
    link_to(html_escape(project.name), href)
  end
end