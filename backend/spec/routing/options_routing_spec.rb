require "rails_helper"

RSpec.describe OptionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/options").to route_to("options#index")
    end

    it "routes to #show" do
      expect(get: "/options/1").to route_to("options#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/options").to route_to("options#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/options/1").to route_to("options#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/options/1").to route_to("options#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/options/1").to route_to("options#destroy", id: "1")
    end
  end
end
