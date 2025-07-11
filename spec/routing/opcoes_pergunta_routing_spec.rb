require "rails_helper"

RSpec.describe OpcoesPerguntaController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/opcoes_pergunta").to route_to("opcoes_pergunta#index")
    end

    it "routes to #new" do
      expect(get: "/opcoes_pergunta/new").to route_to("opcoes_pergunta#new")
    end

    it "routes to #show" do
      expect(get: "/opcoes_pergunta/1").to route_to("opcoes_pergunta#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/opcoes_pergunta/1/edit").to route_to("opcoes_pergunta#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/opcoes_pergunta").to route_to("opcoes_pergunta#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/opcoes_pergunta/1").to route_to("opcoes_pergunta#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/opcoes_pergunta/1").to route_to("opcoes_pergunta#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/opcoes_pergunta/1").to route_to("opcoes_pergunta#destroy", id: "1")
    end
  end
end
