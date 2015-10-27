require 'rails_helper'

RSpec.describe Token, type: :model do
  it 'generates a unique code' do
    code = Token.new.code
    expect(code).to be_present
    expect(code.size).to eq(128)
  end
end
