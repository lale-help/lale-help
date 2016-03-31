require 'rails_helper'

describe "Add task", type: :feature, js: true do

  let(:circle) { create(:circle) }
  let(:circle) { create(:circle) }
  let!(:circle_admin_role) { create :circle_role_admin, circle: circle }
  let(:user_1) { create(:user, primary_circle: circle) }
  let(:user_2) { create(:user, primary_circle: circle) }

  let(:public_group)  { create(:working_group, is_private: false, circle: circle) }
  let(:private_group) { create(:working_group, is_private: true , circle: circle) }

  def fill_in_form
    fill_in "Name",                           with: "Phil Monroe"
    fill_in "Working Group",                  with: :public_group
    fill_in "Description",                    with: "Test Description"
    fill_in "Required number of volunteers",  with: "1"
    select("04/07/2016", :from => "Due Date")
    select("On Day", :from => "Occurs")
    fill_in "Place of task",                  with: "Oakland"
    select("1 Hour", :from => "Time Commitment")
    click_button  "Create Task"
  end

  before do
    circle.roles.send('circle.admin').create user: user_1
    public_group.roles.member.create user: user_1
  end

  context 'regular add task flow' do
    context 'with circle' do
      it "adds a task to the circle" do
        visit(circle_path(circle, as: user_1))
        click_on t('layouts.internal.helpers.header.add')
        fill_in_form

        expect(page).to have_content(t("Due Date"))
      end
    end
  end
end