require 'rails_helper'

describe "Create a task", js: true do
  
  let(:circle)         { create(:circle, :with_admin_and_working_group) }
  let(:admin)          { circle.admin }
  let!(:working_group) { circle.working_groups.first }

  let(:task_form) { PageObject::Task::Form.new }
  let(:task_page) { PageObject::Task::Page.new }

  context "when only required fields are filled" do
  
    let(:inputs) { attributes_for(:task).merge(location: 'Munich') }
    before { task_form.load(circle_id: circle.id, action: :new, as: admin.id) }

    it "creates the task" do
      task_page = task_form.submit_with(inputs)
      expect(task_page.headline.text).to eq(inputs[:name])
      expect(task_page.description.text).to eq(inputs[:description])
      expect(task_page.num_required_volunteers).to eq(1)
      expect(task_page.time_commitment.text).to eq("1 Hour")
      expect(task_page.due_date_as_date).to eq(inputs[:due_date])
      expect(task_page.location.text).to include(inputs[:location])
      expect(task_page.working_group.text).to eq(working_group.name)
      expect(task_page.organizer.text).to eq("Organized by #{admin.name}")
      expect(task_page).not_to have_project
     end
  end

  context "when all fields are filled" do

    let!(:member_2) { create(:user) }
    let!(:working_group_2) { create(:working_group, circle: circle, members: [admin, member_2]) }
    let!(:inputs) { attributes_for(:task, :nondefault, working_group_name: working_group_2.name, organizer_name: member_2.name) }

    before { task_form.load(circle_id: circle.id, action: :new, as: admin.id) }

    it "creates the task" do
      task_page = task_form.submit_with(inputs)
      expect(task_page.headline.text).to eq(inputs[:name])
      expect(task_page.description.text).to eq(inputs[:description])
      expect(task_page.num_required_volunteers).to eq(3)
      expect(task_page.time_commitment.text).to eq("All day")
      expect(task_page.due_date_sentence).to eq("between Wednesday 30 January 2030 12:00 and Thursday 31 January 2030 14:00")
      expect(task_page.location.text).to include(inputs[:location])
      expect(task_page.working_group.text).to eq(inputs[:working_group_name])
      expect(task_page.organizer.text).to eq("Organized by #{member_2.name}")
    end
  end

  context "when form is submitted empty" do
  
    let(:inputs) { {} }
    before { task_form.load(circle_id: circle.id, action: :new, as: admin.id) }
    
    it "shows all error messages" do
      task_form.submit_with(inputs)
      expect(task_form).to be_invalid
      expect(task_form).to have_validation_error("Please enter a name")
      expect(task_form).to have_validation_error("Please enter a description")
    end
  end

end