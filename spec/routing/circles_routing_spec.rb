require "rails_helper"

RSpec.describe CirclesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/circles").to route_to("circles#index")
    end

    it "routes to #new" do
      expect(:get => "/circles/new").to route_to("circles#new")
    end

    it "routes to #show" do
      expect(:get => "/circles/1").to route_to("circles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/circles/1/edit").to route_to("circles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/circles").to route_to("circles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/circles/1").to route_to("circles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/circles/1").to route_to("circles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/circles/1").to route_to("circles#destroy", :id => "1")
    end

  end
end
