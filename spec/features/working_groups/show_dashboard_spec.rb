require 'rails_helper'

describe "Show working group dashboard", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:dashboard_page) { PageObject::WorkingGroup::Dashboard.new }

  let!(:task)   { create(:task, working_group: working_group) }
  let!(:supply) { create(:supply, working_group: working_group) }
  let!(:project) { create(:project, working_group: working_group) }
  let!(:file) { create(:circle_file_upload, uploadable: circle) }

  before { dashboard_page.load(circle_id: circle.id, as: admin.id) }

  it "shows the working group's resources" do
    expect(dashboard_page).to have_task(task)

    dashboard_page.tab_nav.supplies.click
    expect(dashboard_page).to have_supply(supply)
    
    dashboard_page.tab_nav.projects.click
    expect(dashboard_page).to have_project(project)
    
    dashboard_page.tab_nav.documents.click
    expect(dashboard_page).to have_file(file)
  end

  xit "shows organizers and volunteers" do
  end

end