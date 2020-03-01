require 'rails_helper'

describe Circle do

  it { is_expected.to have_many(:roles).class_name(Circle::Role) }
  it { is_expected.to have_many(:tasks).class_name(Task) }
  it { is_expected.to have_many(:supplies).class_name(Supply) }
  it { is_expected.to have_many(:projects).class_name(Project) }
  it { is_expected.to have_many(:organizers).class_name(User) }
  it { is_expected.to have_many(:working_groups).class_name(WorkingGroup) }
  it { is_expected.to have_many(:sponsors).class_name(Sponsor) }
  it { is_expected.to have_many(:sponsorships).class_name(Sponsorship) }

  it { is_expected.to belong_to(:address).class_name(Address) }

  %i(users admins officials volunteers leadership).each do |association|
    it { is_expected.to have_many(association).class_name(User) }
    describe "Circle.new.#{association}" do
      subject(:association) { Circle.new.send(association) }
      Circle::Role.statuses.keys.each do |method|
        it { is_expected.to respond_to(method) }
      end
    end
  end

end