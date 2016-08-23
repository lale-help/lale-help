require 'rails_helper'

describe "Show a circle member profile", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group, :with_volunteer) }
  let(:working_group) { circle.working_groups.first }
  let!(:member)       { circle.admin }
  let(:admin)         { create(:circle_admin_role, circle: circle).user }

  let!(:task_completed_by_member) { create(:task, :completed, working_group: working_group, volunteer: member) }

  let(:member_page) { PageObject::Circle::Member.new }

  before { member_page.load(circle_id: circle.id, member_id: member.id, as: admin.id) }

  it "shows the member page" do
    expect(member_page.headline.text).to eq(member.name)
    expect(member_page.contact.text).to eq(member.email)
    expect(member_page.circles.text).to eq(circle.name)
    expect(member_page.working_group.text).to eq(working_group.name)
    expect(member_page.member_since_date).to eq(admin.created_at.to_date)
    expect(member_page.help_provided.text).to eq("1")
  end

end