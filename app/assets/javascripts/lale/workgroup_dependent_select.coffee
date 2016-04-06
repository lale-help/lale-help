#
# The available projects and organizers of a task (and supply) depends on the
# working group a task/supply is in. This class updates the availabel options for
# a dependent field (projects/organizers) after when the working group changes.
# 
# The code expects an optgroup HTML structure which was generated with Rails' 
# #grouped_collection_select in the dependent field.
#
# Example usages:
# new Lale.WorkgroupDependentSelect('#task_working_group_id', '#task_project_id')
# new Lale.WorkgroupDependentSelect('#supply_working_group_id', '#supply_organizer_id')
class Lale.WorkgroupDependentSelect
  constructor: (workgroup_field_selector, dependent_field_selector) ->
    this.workgroup_field = $(workgroup_field_selector)
    this.field           = $(dependent_field_selector)
    this.all_options     = $(this.field.html())

    this.updateOptions()
    # the "fat arrow" preserves the value of this in the called method :-)
    this.workgroup_field.on 'change', (event) => 
      this.updateOptions()

  updateOptions: ->
    this.field.empty()  
    this.field.append(this.getEmptyOption()) # the empty option is only available sometimes
    this.field.append(this.getNewOptions())
    if this.field.children().length then this.field.parent().show() else this.field.parent().hide()

  getEmptyOption: ->
    this.all_options.clone().filter('option[value=""]')

  getNewOptions: -> 
    working_group = this.workgroup_field.find(':selected').text()
    escaped_wg_name = working_group.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    this.all_options.clone().filter("optgroup[label='#{escaped_wg_name}']").children()

