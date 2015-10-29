require "rails_helper"

RSpec.describe Circle::TasksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/circles/1/tasks").to route_to("circle/tasks#index", :circle_id => "1")
    end

    it "routes to #new" do
      expect(:get => "/circles/1/tasks/new").to route_to("circle/tasks#new", :circle_id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/circles/1/tasks/1/edit").to route_to("circle/tasks#edit", :circle_id => "1", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/circles/1/tasks").to route_to("circle/tasks#create", :circle_id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/circles/1/tasks/1").to route_to("circle/tasks#update", :circle_id => "1", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/circles/1/tasks/1").to route_to("circle/tasks#update", :circle_id => "1", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/circles/1/tasks/1").to route_to("circle/tasks#destroy", :circle_id => "1", :id => "1")
    end

    it "routes to #volunteer" do
      expect(:put   => "/circles/1/tasks/1/volunteer").to route_to("circle/tasks#volunteer", :circle_id => "1", :task_id => "1")
      expect(:patch => "/circles/1/tasks/1/volunteer").to route_to("circle/tasks#volunteer", :circle_id => "1", :task_id => "1")
    end

    it "routes to #complete" do
      expect(:put   => "/circles/1/tasks/1/complete").to route_to("circle/tasks#complete", :circle_id => "1", :task_id => "1")
      expect(:patch => "/circles/1/tasks/1/complete").to route_to("circle/tasks#complete", :circle_id => "1", :task_id => "1")
    end
  end
end
