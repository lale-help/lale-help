require 'rails_helper'

describe "Show project dashboard", js: true do

  let!(:circle)        { create(:circle, :with_admin) }
  let(:admin)          { circle.admin }
  let!(:working_group) { create(:working_group, admin: admin, circle: circle) }
  let!(:project)       { create(:project, working_group: working_group, admin: admin) }

  let(:dashboard_page) { PageObject::Project::Dashboard.new }

  let!(:task)   { create(:task, working_group: working_group, project: project) }
  let!(:supply) { create(:supply, working_group: working_group, project: project) }

  before { dashboard_page.load(circle_id: circle.id, project_id: project.id, as: admin.id) }

  it "shows the project info and resources" do
    expect(dashboard_page.headline.text).to eq(project.name)
    expect(dashboard_page.organizer.text).to eq("JD #{project.admin.name} in#{project.working_group.name}")

    dashboard_page.tab_nav.tasks.click
    expect(dashboard_page).to have_task(task)

    dashboard_page.tab_nav.supplies.click
    expect(dashboard_page).to have_supply(supply)
  end

end