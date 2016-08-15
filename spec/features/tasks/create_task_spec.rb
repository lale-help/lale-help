require 'rails_helper'

describe "Create task", js: true do
  
  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:task_form) { PageObject::Task::Form.new }
  let(:task_page) { PageObject::Task::Page.new }

  before { task_form.load(circle_id: circle.id, as: admin.id) }

  context "when only required fields are filled" do
    # FIXME factor out location to separate test
    let(:inputs) { attributes_for(:task).merge(location: 'Munich') }
    it "creates the task" do
      task_page = task_form.submit_with(inputs)
      expect(task_page.headline.text).to eq(inputs[:name])
      expect(task_page.description.text).to eq(inputs[:description])
      expect(task_page.num_required_volunteers).to eq(1)
      expect(task_page.time_commitment.text).to eq("1 Hour")
      expect(task_page.due_date).to eq(inputs[:due_date])
      expect(task_page.location.text).to include(inputs[:location])
      expect(task_page.working_group.text).to eq(working_group.name)
      expect(task_page.organizer.text).to eq("Organized by #{admin.name}")
      expect(task_page).not_to have_project
     end
  end

  context "when all fields are filled" do
    # FIXME factor out location to separate test
    let(:inputs) { attributes_for(:task).merge(location: 'Munich') }
    it "creates the task" do
      task_page = task_form.submit_with(inputs)
      expect(task_page.headline.text).to eq(inputs[:name])
      expect(task_page.description.text).to eq(inputs[:description])
      expect(task_page.location.text).to include(inputs[:location])
      expect(task_page.due_date).to eq(inputs[:due_date])
     end
  end

  # context "when no mandatory field is filled" do
  #   let(:inputs) { {} }
  #   it "shows all error messages" do
  #     task_form.submit_with(inputs)
  #     expect(task_form).to be_invalid
  #     expect(task_form).to have_validation_error("Name can't be empty")
  #     expect(task_form).to have_validation_error("Please enter a due date")
  #     expect(task_form).to have_validation_error("Please enter a description")
  #     expect(task_form).to have_validation_error("Please enter a location")
  #   end
  # end

end