require "rails_helper"

RSpec.describe RespostaController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/resposta").to route_to("resposta#index")
    end

    it "routes to #new" do
      expect(get: "/resposta/new").to route_to("resposta#new")
    end

    it "routes to #show" do
      expect(get: "/resposta/1").to route_to("resposta#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/resposta/1/edit").to route_to("resposta#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/resposta").to route_to("resposta#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/resposta/1").to route_to("resposta#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/resposta/1").to route_to("resposta#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/resposta/1").to route_to("resposta#destroy", id: "1")
    end
  end
end
