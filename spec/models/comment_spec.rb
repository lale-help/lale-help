require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commenter).class_name(User) }
  it { should belong_to(:task) }
  it { should validate_presence_of(:commenter) }
  it { should validate_presence_of(:task) }
  it { should validate_presence_of(:body) }
end
