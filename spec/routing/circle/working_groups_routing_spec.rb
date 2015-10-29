require "rails_helper"

RSpec.describe Circle::WorkingGroupsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/circles/1/working_groups").to route_to("circle/working_groups#index", :circle_id => "1")
    end

    it "routes to #new" do
      expect(:get => "/circles/1/working_groups/new").to route_to("circle/working_groups#new", :circle_id => "1")
    end

    it "routes to #show" do
      expect(:get => "/circles/1/working_groups/1").to route_to("circle/working_groups#show", :circle_id => "1", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/circles/1/working_groups/1/edit").to route_to("circle/working_groups#edit", :circle_id => "1", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/circles/1/working_groups").to route_to("circle/working_groups#create", :circle_id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/circles/1/working_groups/1").to route_to("circle/working_groups#update", :circle_id => "1", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/circles/1/working_groups/1").to route_to("circle/working_groups#update", :circle_id => "1", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/circles/1/working_groups/1").to route_to("circle/working_groups#destroy", :circle_id => "1", :id => "1")
    end

  end
end
