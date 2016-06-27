require 'rails_helper'

describe "FileUpload abilities" do
  subject(:ability)   { Ability.new(user) }
  let(:circle)        { submit_form(:circle_create_form).result }
  let(:file_upload)   { submit_form(:file_upload_form, uploadable: uploadable, uploader: uploader, is_public: is_public).result }
  let(:is_public)     { true }

  context "for a circle upload" do
    let(:uploadable)    { circle }
    let(:uploader)      { circle.admins.first }

    context "as a guest" do
      let(:user){ nil }
      context "when the file is public" do
        let(:is_public) { true }

        it { is_expected.not_to be_able_to(:read, file_upload) }
        it { is_expected.not_to be_able_to(:manage, file_upload) }
      end

      context "when the file is private" do
        let(:is_public) { false }

        it { is_expected.not_to be_able_to(:read, file_upload) }
        it { is_expected.not_to be_able_to(:manage, file_upload) }
      end
    end

    context "as a circle admin" do
      let(:user){ circle.admins.first }

      context "when the file is public" do
        let(:is_public) { true }

        it { is_expected.to be_able_to(:read, file_upload) }
        it { is_expected.to be_able_to(:manage, file_upload) }
      end

      context "when the file is private" do
        let(:is_public) { false }

        it { is_expected.to be_able_to(:read, file_upload) }
        it { is_expected.to be_able_to(:manage, file_upload) }
      end
    end

    context "as a circle volunteer" do
      let(:user){ create(:user) }
      before do
        create(:circle_role_volunteer, user: user, circle: circle)
      end

      context "when the file is public" do
        let(:is_public) { true }

        it { is_expected.to     be_able_to(:read, file_upload) }
        it { is_expected.not_to be_able_to(:manage, file_upload) }
      end

      context "when the file is private" do
        let(:is_public) { false }

        it { is_expected.not_to be_able_to(:read, file_upload) }
        it { is_expected.not_to be_able_to(:manage, file_upload) }
      end
    end
  end


  #
  # context "as member of a circle" do
  #   let(:user) { create(:circle_volunteer) }
  #   let(:circle) { user.circles.first }
  #
  #   it { should     be_able_to(:read, circle) }
  #   it { should     be_able_to(:create, Circle.new) }
  #   it { should_not be_able_to(:update, circle) }
  #   it { should_not be_able_to(:destroy, circle) }
  #
  #   it { should     be_able_to(:read, working_group) }
  #   it { should_not be_able_to(:create, WorkingGroup.new(circle: circle)) }
  #   it { should_not be_able_to(:update, working_group) }
  #   it { should_not be_able_to(:destroy, working_group) }
  #
  #   it { should     be_able_to(:read, task) }
  #   it { should_not be_able_to(:create, Task.new(working_group: working_group)) }
  #   it { should_not be_able_to(:update, task) }
  #   it { should_not be_able_to(:destroy, task) }
  #   it { should     be_able_to(:volunteer, task) }
  #   it { should_not be_able_to(:complete, task) }
  #
  #   it { should     be_able_to(:read, project) }
  #   it { should_not be_able_to(:update, project) }
  #   it { should_not be_able_to(:delete, project) }
  # end
  #
  # context "as admin of working group" do
  #   let!(:user) { create(:working_group_admin) }
  #   let(:working_group) { user.working_groups.first }
  #   let(:project) { create(:project, working_group: working_group) }
  #
  #   it { should     be_able_to(:read, project) }
  #   it { should     be_able_to(:manage, project) }
  #
  #   context 'private working group' do
  #
  #     before do
  #       @project = create(:project, working_group: working_group)
  #       @project.working_group.update_attribute(:is_private, true)
  #     end
  #
  #     context "own" do
  #       it { should be_able_to(:read, @project) }
  #       it { should be_able_to(:update, @project) }
  #       it { should be_able_to(:delete, @project) }
  #     end
  #
  #     context "someone else's" do
  #       before { user.working_group_roles.destroy_all }
  #       it { should_not be_able_to(:read, @project) }
  #       it { should_not be_able_to(:update, @project) }
  #       it { should_not be_able_to(:delete, @project) }
  #     end
  #   end
  # end
  #
  #
  # context "as working group member" do
  #
  #   let!(:user) { create(:working_group_member) }
  #   let(:working_group) { user.working_groups.first }
  #   let(:project) { create(:project, working_group: working_group) }
  #
  #   before do
  #     @project = create(:project, working_group: working_group)
  #   end
  #
  #   # FIXME fails
  #   # it { should     be_able_to(:read, @project) }
  #   it { should_not be_able_to(:manage, @project) }
  #
  #   context 'private working group' do
  #
  #     before do
  #       @project.working_group.update_attribute(:is_private, true)
  #     end
  #
  #     context "own" do
  #       it { should be_able_to(:read, @project) }
  #       it { should_not be_able_to(:update, @project) }
  #       it { should_not be_able_to(:delete, @project) }
  #     end
  #
  #     context "someone else's" do
  #       before { user.working_group_roles.destroy_all }
  #       it { should_not be_able_to(:read, @project) }
  #       it { should_not be_able_to(:update, @project) }
  #       it { should_not be_able_to(:delete, @project) }
  #     end
  #   end
  # end

end
