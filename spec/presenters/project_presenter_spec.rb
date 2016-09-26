require 'rails_helper'

describe ProjectPresenter do
  describe "calendar_leaf_title_date" do

    let(:presenter) { ProjectPresenter.new(project) }

    context "project has tasks" do
      let(:task_1)    { create(:task, due_date: Date.parse("2016-09-01")) }
      let(:task_2)    { create(:task, due_date: Date.parse("2016-10-31")) }
      let(:project)   { create(:project, tasks: [task_1, task_2]) }

      context "current date is in project range" do
        before { Timecop.freeze(Time.parse("2016-09-30")) }
        after  { Timecop.return }
        it "shows the current month" do
          expect(presenter.calendar_leaf_title_date.month).to eq(9)
        end
      end

      context "current date is after project range" do
        before { Timecop.freeze(Time.parse("2016-11-01")) }
        after  { Timecop.return }
        it "shows the project's last month" do
          expect(presenter.calendar_leaf_title_date.month).to eq(10)
        end
      end

      context "current date is before project range" do
        before { Timecop.freeze(Time.parse("2016-08-01")) }
        after  { Timecop.return }
        it "shows the project's first month" do
          expect(presenter.calendar_leaf_title_date.month).to eq(9)
        end
      end
    end

    context "project has no tasks" do
      let(:project)   { create(:project) }
      before { Timecop.freeze(Time.parse("2016-11-01")) }
      after  { Timecop.return }
      it "shows the current month" do
        expect(presenter.calendar_leaf_title_date.month).to eq(11)
      end
    end

  end
end