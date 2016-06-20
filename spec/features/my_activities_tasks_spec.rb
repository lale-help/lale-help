require 'rails_helper'

describe 'Task in My Activities', type: :feature, js: true do

  context 'For a user who has volunteered and assigned tasks' do

    let!(:circle) { submit_form(:circle_create_form).result }
    let!(:public_group)  { create(:working_group, is_private: false, circle: circle) }
    let!(:admin) { circle.admin }
    let!(:task_organizer_only) {create(:task, working_group: public_group, volunteer_count_required: 1, organizer: admin)}
    let!(:task_assigned_only) {create(:task, working_group: public_group, volunteer_count_required: 1)}
    let!(:task_organizer_and_assigned) {create(:task, working_group: public_group, volunteer_count_required: 1, organizer: admin)}


    it 'lists the correct volunteering tasks and organizing tasks in My Activities' do
      Task::Volunteer.run(user: admin, task: task_assigned_only) # Assign the admin two of the three tasks
      Task::Volunteer.run(user: admin, task: task_organizer_and_assigned)
      visit root_path(as: admin)
      click_on t('layouts.internal.sidebar.my-calendar') # Click on My Activities in the sidebar
      find('.selected', text: t('circle.taskables.nav.volunteering')) # Confirm you're in the Volunteering Tab
      expect(page).to have_content task_assigned_only.name
      expect(page).to have_content task_organizer_and_assigned.name
      expect(page).not_to have_content task_organizer_only.name
      click_on t('circle.taskables.nav.organizing')
      find('.selected', text: t('circle.taskables.nav.organizing')) # Confirm you're in the Organizing Tab
      expect(page).to have_content task_organizer_only.name
      expect(page).to have_content task_organizer_and_assigned.name
      expect(page).not_to have_content task_assigned_only.name
    end

  end
end
