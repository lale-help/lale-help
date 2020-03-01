require 'rails_helper'

describe "Show working group dashboard", js: true do

  let(:circle)        { create(:circle, :with_admin) }
  let(:admin)         { circle.admin }
  let(:working_group) { create(:working_group, :with_members, circle: circle, admin: admin) }
  let(:volunteers)    { working_group.members }

  let(:dashboard_page) { PageObject::WorkingGroup::Dashboard.new }

  let!(:task)   { create(:task, working_group: working_group, organizer: volunteers.first) }
  let!(:supply) { create(:supply, working_group: working_group, organizer: volunteers.first) }
  let!(:project) { create(:project, working_group: working_group) }
  let!(:file) { create(:working_group_file_upload, uploadable: working_group) }

  before { dashboard_page.load(circle_id: circle.id, wg_id: working_group.id, as: admin.id) }

  it "shows the working group's resources" do
    expect(dashboard_page.headline.text).to eq(working_group.name)

    expect(dashboard_page).to have_task(task)

    dashboard_page.tab_nav.supplies.click
    expect(dashboard_page).to have_supply(supply)

    dashboard_page.tab_nav.projects.click
    expect(dashboard_page).to have_project(project)

    dashboard_page.tab_nav.documents.click
    expect(dashboard_page).to have_file(file)
  end

  it "shows organizers and volunteers" do
    expect(dashboard_page).to have_organizer(admin)
    expect(dashboard_page.organizers.size).to eq(1)
    expect(dashboard_page).to have_volunteer(admin)
    expect(dashboard_page).to have_volunteer(volunteers[0])
    expect(dashboard_page).to have_volunteer(volunteers[1])
    expect(dashboard_page.volunteers.size).to eq(3)
  end

end