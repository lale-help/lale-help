require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "works! (now write some real specs)" do
      get circle_tasks_path(@circle)
      expect(response).to have_http_status(200)
    end
  end
end
