require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commenter).class_name(User) }
  it { should belong_to(:item) }
  it { should validate_presence_of(:commenter) }
  it { should validate_presence_of(:item) }
  it { should validate_presence_of(:body) }
end
