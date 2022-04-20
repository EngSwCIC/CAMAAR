require "rails_helper"

RSpec.describe LikertQuestionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/likert_questions").to route_to("likert_questions#index")
    end

    it "routes to #show" do
      expect(get: "/likert_questions/1").to route_to("likert_questions#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/likert_questions").to route_to("likert_questions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/likert_questions/1").to route_to("likert_questions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/likert_questions/1").to route_to("likert_questions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/likert_questions/1").to route_to("likert_questions#destroy", id: "1")
    end
  end
end
