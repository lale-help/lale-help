require 'rails_helper'

describe 'Navigating to a task', js: true do
  context 'when the task exists and the user owns it' do

    let!(:circle) { submit_form(:circle_create_form).result }
    let(:admin) { circle.admin }
    let!(:working_group) { create(:working_group, circle: circle) }
    let!(:role) { create(:working_group_admin_role, user: admin, working_group: working_group) }
    let!(:task) { create(:urgent_task, organizer: admin, working_group: working_group) }

    it 'is successful' do
      # when things aren't working as expected you may want to verify your setup, like this for example:
      expect(task.organizer).to eq(admin)
      expect(task.working_group).to eq(working_group)

      visit root_path(as: admin)

      find("div.task-title", text: task.name).click

      # expect the title of the next page to be there.
      # this will also wait until the next page has loaded
      selector = "body[data-controller='circle/tasks'] .task.urgency--urgent"
      expect(page).to have_css(selector)

      # click it
      find(selector).click
    end
  end
end
