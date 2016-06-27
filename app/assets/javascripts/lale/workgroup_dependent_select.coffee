#
# In some of our forms, select fields deplend on each other, i.e. the available options for one
# select field have to change when another, select field changes. This class handles those changes.
#
# An example for the task form: when the working group is changed, the available organizers need
# to be updated to show all organizers of that working group.
#
# In order to work, the class needs an optgroup HTML structure generated with
# #grouped_collection_select in the dependent field.
#
# Example usage:
# new Lale.WorkgroupDependentSelect('#task_working_group_id', '#task_project_id')
#
class Lale.WorkgroupDependentSelect
  constructor: (workgroup_field_selector, dependent_field_selector, config = {hideOnEmpty: false}) ->
    this.config          = config
    this.workgroup_field = $(workgroup_field_selector)
    this.field           = $(dependent_field_selector)
    this.all_options     = $(this.field.html())

    return unless @field.length > 0
    return unless @workgroup_field.length > 0
    return if @field.attr('type') == "hidden"

    this.updateOptions()
    # the "fat arrow" preserves the value of this in the called method :-)
    this.workgroup_field.on 'change', (event) =>
      this.updateOptions()

  updateOptions: ->
    this.field.empty()
    this.field.append(this.getEmptyOption()) # the empty option not always available
    newOptions = this.getNewOptions()
    this.field.append(newOptions)
    if this.config.hideOnEmpty
      if newOptions.length then this.field.parent().show() else this.field.parent().hide()

  getEmptyOption: ->
    this.all_options.clone().filter('option[value=""]')


  workingGroupName: ->
    if @workgroup_field.attr('type') == "hidden"
      working_group = @workgroup_field.siblings('input').val()
    else
      working_group = this.workgroup_field.find(':selected').text()

    escaped_wg_name = working_group.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')


  getNewOptions: ->
    this.all_options.clone().filter("optgroup[label='#{@workingGroupName()}']").children()

