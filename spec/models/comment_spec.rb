require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to(:commenter).class_name(User) }
  it { is_expected.to belong_to(:item) }
  it { is_expected.to validate_presence_of(:commenter) }
  it { is_expected.to validate_presence_of(:item) }
  it { is_expected.to validate_presence_of(:body) }
end
