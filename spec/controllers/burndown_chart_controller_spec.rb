require 'rails_helper'

RSpec.describe BurndownChartController, type: :controller do

  let(:volunteer){FactoryGirl.create(:volunteer)}
  describe "GET #index" do
    it "returns http success" do
      get :index, { volunteer_id: volunteer.id }
      expect(response).to have_http_status(:success)
    end
  end

end
