require 'rails_helper'

describe Circle::Role do

  let(:circle) { create(:circle) }
  let(:user)   { create(:user) }
  subject      { circle.roles.create(role_type: 'circle.admin', user: user) }

  it { is_expected.to be_active }

end