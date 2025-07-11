require "rails_helper"

RSpec.describe DisciplinasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/disciplinas").to route_to("disciplinas#index")
    end

    it "routes to #new" do
      expect(get: "/disciplinas/new").to route_to("disciplinas#new")
    end

    it "routes to #show" do
      expect(get: "/disciplinas/1").to route_to("disciplinas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/disciplinas/1/edit").to route_to("disciplinas#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/disciplinas").to route_to("disciplinas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/disciplinas/1").to route_to("disciplinas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/disciplinas/1").to route_to("disciplinas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/disciplinas/1").to route_to("disciplinas#destroy", id: "1")
    end
  end
end
