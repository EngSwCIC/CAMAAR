require "rails_helper"

RSpec.describe "LoginController", type: :request do
  let(:usuario) { create(:usuario, role: :estudante) }

  def login_as(u)
    post login_path, params: { email: u.email, password: "Senha123" }
  end

  describe "DELETE /logout" do
    it "encerra a sessão e redireciona para o login (Happy Path)" do
      login_as(usuario)
      delete logout_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("saiu")
    end
  end
end
