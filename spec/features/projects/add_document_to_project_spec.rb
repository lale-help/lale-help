require 'rails_helper'

describe "Add Document to a Project", js: true do

  let!(:circle)        { create(:circle, :with_admin) }
  let(:admin)          { circle.admin }
  let!(:working_group) { create(:working_group, admin: admin, circle: circle) }
  let!(:project)       { create(:project, working_group: working_group, admin: admin) }

  let(:dashboard_page) { PageObject::Project::Dashboard.new }

  let(:local_file_path) { File.expand_path('spec/fixtures/images/avatar.jpg') }
  let(:file_name)       { "Test File" }

  before { dashboard_page.load(circle_id: circle.id, project_id: project.id, as: admin.id) }
  before { dashboard_page.tab_nav.documents.click }

  it "successfully" do
    dashboard_page.add_document_button.click
    fill_in     FileUpload.human_attribute_name(:name), with: file_name
    attach_file FileUpload.human_attribute_name(:file), local_file_path
    find("input[type=submit]").click

    dashboard_page.load(circle_id: circle.id, project_id: working_group.id, as: admin.id)
    dashboard_page.when_loaded do
      dashboard_page.tab_nav.documents.click
      expect(dashboard_page.files.count).to eq 1
    end
  end

end