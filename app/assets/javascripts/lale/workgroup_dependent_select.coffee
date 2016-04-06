#
# The available projects and organizers of some entities (a task, supply or project) depend 
# on the working group it is in. This class updates the available options when the working
# group changes.
# 
# Example: when the workgroup is changed in the task form, the available organizers need 
# to change to all organizers of the new workgroup.
# 
# In order to work, the class needs an optgroup HTML structure generated with
# #grouped_collection_select in the dependent field.
#
# Example usage:
# new Lale.WorkgroupDependentSelect('#task_working_group_id', '#task_project_id')
# 
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
    this.field.append(this.getEmptyOption()) # the empty option not always available
    this.field.append(this.getNewOptions())
    if this.field.children().length then this.field.parent().show() else this.field.parent().hide()

  getEmptyOption: ->
    this.all_options.clone().filter('option[value=""]')

  getNewOptions: -> 
    working_group = this.workgroup_field.find(':selected').text()
    escaped_wg_name = working_group.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    this.all_options.clone().filter("optgroup[label='#{escaped_wg_name}']").children()

