require 'rails_helper'

describe Project::BaseForm do

  let(:ability) { Ability.new(user) }

  # user must be in the circle for things to work, so it's easiest to set this up by creating a role.
  let(:user_circle_role) { create(:circle_role_volunteer) }
  let(:user) { user_circle_role.user }
  let(:circle) { user_circle_role.circle }

  # these are the defaults, often overridden in contexts below.
  let(:params) { { user: user, circle: circle, ability: ability } }

  # object under test.
  let(:form) { Project::Create.new(params) }

  describe ".new" do
    describe "default attributes" do
      describe "project" do

        context "no project given" do
          it "builds a new project" do
            expect(form.project).to be_present
            expect(form.project).not_to be_persisted
            expect(form.project.circle).to be_nil # sic! verify.
          end
        end

        context "project given" do
          let(:project) { create(:project) }
          let(:params) { { user: user, circle: circle, ability: ability, project: project } }
          it "uses that project" do
            expect(form.project).to eq(project)
          end
        end

      end

      describe "organizer_id" do
        context "organizer_id given" do
          let(:organizer_id) { create(:user).id }
          let(:params) { { user: user, circle: circle, ability: ability, organizer_id: organizer_id } }
          it "uses it" do
            expect(form.organizer_id).to eq(organizer_id)
          end
        end

        context "no organizer_id given" do
          context "project has an admin" do
            let(:project_admin_role) { create(:project_admin_role) }
            let(:project_admin) { project_admin_role.user }
            let(:project) { project_admin_role.project }
            let(:params) { { user: project_admin, circle: circle, ability: ability, project: project } }

            it "uses the project admin" do
              expect(form.organizer_id).to eq(project_admin.id)
              expect(form.organizer_id).not_to be(nil)
            end
          end

          context "project has no admin" do
            it "organizer_id is nil" do
              expect(form.organizer_id).to be(nil)
            end
          end
        end
      end
    end

    describe "available_working_groups" do
      context "circle has a working group" do
        let!(:wg) { create(:working_group, circle: circle)}
        before { allow(ability).to receive(:can?) { true } } # gnah
        it "is included" do
          expect(form.available_working_groups).to include(wg)
        end
      end
      # TODO test contexts here
    end

    describe "available_working_groups_disabled?" do
      let(:params) { { user: user, circle: circle, ability: ability, project: project } }
      context 'new project' do
        let(:project) { build(:project) }
        it 'returns false' do
          expect(form.available_working_groups_disabled?).to be(false)
        end
      end
      context 'existing project' do
        let(:project) { create(:project) }
        it 'returns true' do
          expect(form.available_working_groups_disabled?).to be(true)
        end
      end
    end
  end

  describe "#submit" do
    let(:wg) { create(:working_group, circle: circle) }
    let(:name) { attributes_for(:project)[:name] }
    let(:params) { { user: user, circle: circle, ability: ability, working_group_id: wg.id, name: name, organizer_id: user.id, start_date: Date.today } }
    context "valid attributes given" do
      it "creates a project" do
        outcome = nil # define outer variable here so I can access it outside the block
        expect { outcome = form.submit }.to change { Project.count }.by(1)
        expect(outcome).to be_success
        expect(outcome.errors).to be_nil
      end
    end

    context "no organizer_id given" do
      let(:params) { { user: user, circle: circle, ability: ability, working_group_id: wg.id, name: name } }
      it "has an error" do
        outcome = nil # define outer variable here so I can access it outside the block
        expect { outcome = form.submit }.not_to change { Project.count }
        expect(outcome).not_to be_success
        expect(outcome.errors[:organizer_id]).not_to be_nil
      end
    end

    context "no start_date given" do
      let(:params) { { user: user, circle: circle, ability: ability, working_group_id: wg.id, name: name, organizer_id: user.id } }
      it "has an error" do
        outcome = nil # define outer variable here so I can access it outside the block
        expect { outcome = form.submit }.not_to change { Project.count }
        expect(outcome).not_to be_success
        expect(outcome.errors[:start_date]).not_to be_nil
      end
    end
  end

end
