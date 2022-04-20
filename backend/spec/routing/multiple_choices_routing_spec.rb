require "rails_helper"

RSpec.describe MultipleChoicesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/multiple_choices").to route_to("multiple_choices#index")
    end

    it "routes to #show" do
      expect(get: "/multiple_choices/1").to route_to("multiple_choices#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/multiple_choices").to route_to("multiple_choices#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/multiple_choices/1").to route_to("multiple_choices#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/multiple_choices/1").to route_to("multiple_choices#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/multiple_choices/1").to route_to("multiple_choices#destroy", id: "1")
    end
  end
end
