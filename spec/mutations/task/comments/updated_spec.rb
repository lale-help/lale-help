require 'rails_helper'

describe Task::Comments::Updated do
  let(:task) { create(:task) }
  let(:user) { create(:user) }

  describe '#execute' do
    
    context "task unchanged" do
      it "doesn't create a comment" do
        expect { Task::Comments::Updated.run(task: task, user: user) }.not_to change { Comment.count }
      end
    end

    context "task changed" do

      before { task.name = task.name + " Hello" }

      it 'is successful' do
        outcome = Task::Comments::Updated.run(task: task, user: user, changes: task.changes)
        expect(outcome).to be_success
      end

      it 'creates a comment' do
        expect { Task::Comments::Updated.run(task: task, user: user, changes: task.changes) }.to change { Comment.count }.by(1)
      end

      it "sets the correct values on the comment" do
        Task::Comments::Updated.run(task: task, user: user, changes: task.changes)
        comment = Comment.last
        expect(comment.item).to eq(task)
        expect(comment.body).to include(user.name)
        expect(comment.body).to include(Task.human_attribute_name(:name))
      end
    end
  end
end
