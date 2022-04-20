require "rails_helper"

RSpec.describe LikertScalesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/likert_scales").to route_to("likert_scales#index")
    end

    it "routes to #show" do
      expect(get: "/likert_scales/1").to route_to("likert_scales#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/likert_scales").to route_to("likert_scales#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/likert_scales/1").to route_to("likert_scales#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/likert_scales/1").to route_to("likert_scales#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/likert_scales/1").to route_to("likert_scales#destroy", id: "1")
    end
  end
end
