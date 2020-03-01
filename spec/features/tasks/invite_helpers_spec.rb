require 'rails_helper'

describe "Invite helpers to a task", js: true do

  let(:circle)        { create(:circle, :with_admin) }
  let(:admin)         { circle.admin }

  let!(:circle_member) { create(:circle_member_role, circle: circle).user }
  let!(:wg_members)    { create_list(:user, 2) }
  let(:working_group)  { create(:working_group, circle: circle, members: wg_members) }


  let!(:task) { create(:task, working_group: working_group) }

  let(:task_page) { PageObject::Task::Page.new }

  before { task_page.load_for(task, as: admin) }

  describe "invite working group" do
    it "works" do
      task_page.find_helpers_button.click
      task_page.invite_users_form.invite_working_group.click
      task_page.invite_users_form.submit_button.click
      expect(task_page).to have_flash('Invited 3 members.')
      expect(sent_emails.map(&:to).flatten).to match_array(wg_members.map(&:email) + [task.organizer.email])
    end
  end

  describe "invite circle" do

    it "works" do
      task_page.find_helpers_button.click
      task_page.invite_users_form.invite_circle.click
      task_page.invite_users_form.submit_button.click
      expect(task_page).to have_flash('Invited 4 members.')
      expect(sent_emails.map(&:to).flatten).to match_array(([circle_member, task.organizer] + wg_members).map(&:email))
    end
  end

end