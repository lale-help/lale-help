require "rails_helper"

RSpec.describe WorkingGroupsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/working_groups").to route_to("working_groups#index")
    end

    it "routes to #new" do
      expect(:get => "/working_groups/new").to route_to("working_groups#new")
    end

    it "routes to #show" do
      expect(:get => "/working_groups/1").to route_to("working_groups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/working_groups/1/edit").to route_to("working_groups#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/working_groups").to route_to("working_groups#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/working_groups/1").to route_to("working_groups#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/working_groups/1").to route_to("working_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/working_groups/1").to route_to("working_groups#destroy", :id => "1")
    end

  end
end
