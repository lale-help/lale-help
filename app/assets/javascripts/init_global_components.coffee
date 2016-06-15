#
# This file is intended to initialize JS components that we use on several pages.
# No page-specific selectors should be used in here (thus, _components_).
# 
ready = ->
  # tabbed horizontal navigation that we use on the collection pages 
  # (circle, working group and project dashboards)
  new Lale.TabNav('.tab-nav', '.tab')

  # show/hide completed tasks & supplies
  new Lale.StatusLink('.tab.tasks a.task_status', '.tab.tasks .task_section')
  new Lale.StatusLink('.tab.supplies a.task_status', '.tab.supplies .task_section')

$(document).on 'ready', ready
$(document).on 'page:load', ready
