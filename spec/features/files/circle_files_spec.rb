require 'rails_helper'

describe 'Circle Files', type: :feature, js: true do
  context 'uploading a file' do

    let!(:circle) { submit_form(:circle_create_form).result }
    let!(:admin) { circle.admins.first }

    let(:local_file_path) { File.expand_path('app/assets/images/avatar.jpeg') }

    let(:file_name) { "Test File" }

    it 'works' do
      visit root_path(as: admin)
      click_on t('layouts.internal.sidebar.admin')
      click_on t('circle.admins.nav.files')
      click_on t('circle.admins.files.new-file')

      fill_in     FileUpload.human_attribute_name(:name), with: file_name
      attach_file FileUpload.human_attribute_name(:file), local_file_path
      find("input[type=submit]").click

      expect(page).to have_content(file_name)

      visit circle_path(circle)

      within '.panel.files' do
        expect(page).to have_content(file_name)
      end
    end
  end
end
