require 'rails_helper'
require "cancan/matchers"

describe "Volunteer" do
  describe "abilities", :skip do
    subject(:ability)   { Ability.new(user) }
    let(:circle)        { create(:circle) }
    let(:working_group) { create(:working_group, circle: circle) }
    let(:task)          { create(:task, working_group: working_group) }

    context "as a guest" do
      let(:user){ nil }
      it{ should     be_able_to(:read, circle) }
      it{ should     be_able_to(:create, Circle.new) }
      it{ should_not be_able_to(:update, circle) }
      it{ should_not be_able_to(:destroy, circle) }
      it{ should_not be_able_to(:complete, task) }
    end

    context "when is a circle admin" do
      let(:user){ circle.admin }

      it{ should     be_able_to(:read, circle) }
      it{ should_not be_able_to(:create, Circle.new) }
      it{ should     be_able_to(:update, circle) }
      it{ should     be_able_to(:destroy, circle) }

      it{ should     be_able_to(:read, working_group) }
      it{ should     be_able_to(:create, WorkingGroup.new(circle: circle)) }
      it{ should     be_able_to(:update, working_group) }
      it{ should     be_able_to(:destroy, working_group) }

      it{ should     be_able_to(:read, task) }
      it{ should     be_able_to(:create, Task.new(working_group: working_group)) }
      it{ should     be_able_to(:update, task) }
      it{ should     be_able_to(:destroy, task) }
      it{ should     be_able_to(:volunteer, task) }
      it{ should_not be_able_to(:complete, task) }
    end

    context "when is a member of a circle" do
      let(:user){ FactoryGirl.create(:volunteer, circle: circle) }

      it{ should     be_able_to(:read, circle) }
      it{ should_not be_able_to(:create, Circle.new) }
      it{ should_not be_able_to(:update, circle) }
      it{ should_not be_able_to(:destroy, circle) }

      it{ should     be_able_to(:read, working_group) }
      it{ should_not be_able_to(:create, WorkingGroup.new(circle: circle)) }
      it{ should_not be_able_to(:update, working_group) }
      it{ should_not be_able_to(:destroy, working_group) }

      it{ should     be_able_to(:read, task) }
      it{ should_not be_able_to(:create, Task.new(working_group: working_group)) }
      it{ should_not be_able_to(:update, task) }
      it{ should_not be_able_to(:destroy, task) }
      it{ should     be_able_to(:volunteer, task) }
      it{ should_not be_able_to(:complete, task) }

      context "have volenteered for a task" do
        before(:each) { task.volunteers << user; task.save }
        it{ should_not be_able_to(:volunteer, task) }
        it{ should     be_able_to(:complete, task) }
        context "and has completed it" do
          before(:each) { task.complete = true; task.save }
          it{ should_not be_able_to(:volunteer, task) }
          it{ should_not be_able_to(:complete, task) }
        end
      end
    end
  end
end
