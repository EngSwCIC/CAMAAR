require 'rails_helper'

describe Users::SessionsController do
  describe "GET new" do
    it "mostra a tela de login" do
      get :new
      expect(response).to render_template("devise/sessions/new")
    end
  end
end
