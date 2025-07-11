require "rails_helper"

RSpec.describe MatriculasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/matriculas").to route_to("matriculas#index")
    end

    it "routes to #new" do
      expect(get: "/matriculas/new").to route_to("matriculas#new")
    end

    it "routes to #show" do
      expect(get: "/matriculas/1").to route_to("matriculas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/matriculas/1/edit").to route_to("matriculas#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/matriculas").to route_to("matriculas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/matriculas/1").to route_to("matriculas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/matriculas/1").to route_to("matriculas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/matriculas/1").to route_to("matriculas#destroy", id: "1")
    end
  end
end
