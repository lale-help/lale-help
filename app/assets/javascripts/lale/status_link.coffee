class Lale.StatusLink
  constructor: (link_selector, section_selector) ->
    this.sections  = $(section_selector)
    first_section  = this.sections.first().data('tab')
    this.showSection(first_section)
    $(link_selector).on 'click', (event) =>
      this.handleLinkClick(event)

  handleLinkClick: (event) ->
    name = $(event.target).data('tab')
    this.showSection(name)

  showSection: (name) ->
    this.sections.hide().filter(".#{name}").show()
