require 'rails_helper'

describe 'Completing and Reopening Tasks', type: :feature, js: true do

  context 'when the task exists and a user owns it' do

    let!(:circle) { submit_form(:circle_create_form).result }
    let!(:public_group)  { create(:working_group, is_private: false, circle: circle) }
    let!(:admin) { circle.admin }
    let!(:role) { create(:working_group_admin_role, user: admin, working_group: public_group) }
    let!(:task) { create(:urgent_task, organizer: admin, working_group: public_group) }


    it 'can complete successfully' do
      visit root_path(as: admin)
      find("div.task-title", text: task.name).click
      selector = "body[data-controller='circle/tasks'] .task.urgency--urgent"
      expect(page).to have_css(selector)
      find('.button-super', text: t('circle.tasks.edit_actions.edit_button_dropdown')).click
      click_on(t('circle.tasks.show.complete-task-button'))
      expect(circle.tasks.completed).to eq([task])
    end

    it 'can be reopened after being completed' do
      Task::Assign.run(users: [admin], task: task, current_user: admin)
      Task::Complete.run(user: admin, task: task)
      visit root_path(as: admin)
      expect(page).to have_content(t('circle.working_groups.show.show_completed_tasks'))
      find('.task_status').click #click the completed tasks link on the home page
      find('div.task-title', text: task.name).click
      selector = "div.task"
      expect(page).to have_css(selector)
      expect(page).to have_content(t('circle.supplies.show.task-complete'))
      find('.button-super', text: t('circle.tasks.edit_actions.edit_button_dropdown')).click
      click_on(t('helpers.reopen', model: "Task"))
      expect(circle.tasks.not_completed).to eq([task])
    end
  end
end
