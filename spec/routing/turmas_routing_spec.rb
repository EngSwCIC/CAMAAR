require "rails_helper"

RSpec.describe TurmasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/turmas").to route_to("turmas#index")
    end

    it "routes to #new" do
      expect(get: "/turmas/new").to route_to("turmas#new")
    end

    it "routes to #show" do
      expect(get: "/turmas/1").to route_to("turmas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/turmas/1/edit").to route_to("turmas#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/turmas").to route_to("turmas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/turmas/1").to route_to("turmas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/turmas/1").to route_to("turmas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/turmas/1").to route_to("turmas#destroy", id: "1")
    end
  end
end
