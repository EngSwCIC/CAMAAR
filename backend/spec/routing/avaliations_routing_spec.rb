require "rails_helper"

RSpec.describe AvaliationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/avaliations").to route_to("avaliations#index")
    end

    it "routes to #show" do
      expect(get: "/avaliations/1").to route_to("avaliations#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/avaliations").to route_to("avaliations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/avaliations/1").to route_to("avaliations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/avaliations/1").to route_to("avaliations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/avaliations/1").to route_to("avaliations#destroy", id: "1")
    end
  end
end
