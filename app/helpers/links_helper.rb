module LinksHelper

  def link_to_user(user, text: user.name)
    # FIXME may need to be adapted to multicircle
    href = circle_member_path(user.primary_circle, user)
    link_to(html_escape(text), href)
  end
  
  def link_to_working_group(wg, text: wg.name)
    href = circle_working_group_path(wg.circle, wg)
    link_to(html_escape(text), href)
  end

  def link_to_circle(circle, text: circle.name)
    href = circle_path(circle)
    link_to(html_escape(text), href)
  end

  def link_to_project(project, text: project.name)
    href = circle_project_path(project.circle, project)
    link_to(html_escape(text), href)
  end
  
end