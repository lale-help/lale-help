require 'rails_helper'

describe 'The Add menu' do
  context 'when user is working group admin' do

    let!(:circle) { submit_form(:circle_create_form).result }
    let(:admin) { circle.admin }
    let!(:working_group) { create(:working_group, circle: circle) }
    let!(:role) { create(:working_group_admin_role, user: admin, working_group: working_group) }

    it 'has a link to the supply form' do
      # when things aren't working as expected you may want to verify your setup, like this for example:
      expect(Circle.count).to eq(1)
      expect(circle.working_groups).to include(working_group)
      # a user needs to be working group admin in order to create tasks & supplies
      expect(working_group.admins).to include(admin)

      visit root_path(as: admin)
      # unfortunately the Add "button" is not a button but just a plain div
      # the click_on method is actually an alias for #click_link_or_button. so it won't 
      # consider a div for clicking :-(
      #click_on("Add")
      # to work around this, you can use the swiss army knife of DOM exploration, #find, and call
      # click on the node it returns. It's documented here and takes the same options as #find_all: 
      # http://www.rubydoc.info/github/jnicklas/capybara/Capybara/Node/Finders
      find('.button-super', text: /Add/).click
      # once the dropdown menu has been displayed by clicking on it, the following works as expected.
      # keep in mind Capybara tries to behave like a user, so it won't "see" hidden HTML elements.
      click_on("Supply")
      # show!
      expect(page).to have_content("Create a new Supply")
    end
  end
end
