require 'rails_helper'

describe Task::Role do

  let(:relevant_attrs) { {role_type: 'task.organizer', user_id: 42, task_id: 4711 } }
  let(:task_1) { Task::Role.new(relevant_attrs) }

  describe "==" do

    context "all relevant attributes match" do
      let(:task_2) { Task::Role.new(relevant_attrs) }
      it "returns true" do
        expect(task_2 == task_1).to be(true)
      end
    end

    context "role type mismatch" do
      let(:task_2) { Task::Role.new(relevant_attrs.merge(role_type: 'task.volunteer')) }
      it "returns false" do
        expect(task_2 == task_1).to be(false)
      end
    end

    context "user id mismatch" do
      let(:task_2) { Task::Role.new(relevant_attrs.merge(user_id: 1)) }
      it "returns false" do
        expect(task_2 == task_1).to be(false)
      end
    end

    context "task id mismatch" do
      let(:task_2) { Task::Role.new(relevant_attrs.merge(task_id: 1)) }
      it "returns false" do
        expect(task_2 == task_1).to be(false)
      end
    end

  end
end