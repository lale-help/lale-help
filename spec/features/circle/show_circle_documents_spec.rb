require 'rails_helper'

describe "Show circle documents", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }

  let(:documents_page) { PageObject::Circle::Documents.new }

  context "circle has a document" do

    let!(:document) { create(:circle_file_upload, uploadable: circle) }

    before { documents_page.load(circle_id: circle.id, as: admin.id) }

    it "shows the file" do
      expect(documents_page).to have_circle_document(document)
    end
  end

  context "working group has a document" do

    let(:working_group) { circle.working_groups.first }
    let!(:document) { create(:circle_file_upload, uploadable: working_group) }

    before { documents_page.load(circle_id: circle.id, as: admin.id) }

    it "shows the file" do
      documents_page.tab_nav.wg_documents.click
      expect(documents_page).to have_wg_document(document)
    end
  end
end