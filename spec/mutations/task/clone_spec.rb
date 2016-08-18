require 'rails_helper'


describe Task::Clone do

  let(:task) { create(:task, :with_location) }

  def cloned_task
    Task::Clone.run(task: task).result
  end

  describe '#run' do

    context "task has attributes" do

      def cloned_attribute_keys
        Task.new.attributes.reject do |key, _|
          %w(id created_at updated_at completed_at).include?(key)
        end.keys
      end

      it "copies the attributes" do
        cloned_attribute_keys.each do |attr|
          expect(cloned_task.send(attr)).to eq(task.send(attr))
        end
      end
    end

    context "task has primary location" do

      it "copies the location" do
        # WARNING: primary_location on a cloned task is not what you would expect.
        # See the implementation for details.
        expect(cloned_task.primary_location.address).to eq(task.primary_location.address)
      end

      it "is readonly" do
        expect(cloned_task).to be_readonly
      end
    end

  end
end
