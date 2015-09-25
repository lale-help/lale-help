require 'rails_helper'

RSpec.describe "Circles", type: :request do
  describe "GET /circles" do
    it "works! (now write some real specs)" do
      get circles_path
      expect(response).to have_http_status(200)
    end
  end
end
