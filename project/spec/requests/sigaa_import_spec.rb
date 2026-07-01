require "rails_helper"

RSpec.describe "Importação de Dados do SIGAA", type: :request do
  let!(:admin) { create(:user, :admin, department: create(:department, code: "CIC")) }

  it "exibe a tela de importação para administradores autenticados" do
    login_as(admin)
    get imports_sigaa_path

    expect(response).to have_http_status(:success)
    expect(response.body).to include("Importação de Dados do SIGAA")
    expect(response.body).to include("2021.2")
  end

  it "sincroniza os dados do SIGAA e exibe mensagem de conclusão" do
    login_as(admin)

    expect do
      post imports_sigaa_path, params: { sigaa_sync: { semester: "2021.2" } }
    end.to change(CourseClass, :count).by_at_least(1)
      .and change(User.participant, :count).by_at_least(1)

    expect(response).to redirect_to(imports_sigaa_path)
    follow_redirect!
    expect(response.body).to match(/Sincronização concluída\. \d+ novos registros adicionados e \d+ registros atualizados\./)
  end

  it "informa quando a base já está atualizada para o período" do
    login_as(admin)
    Sigaa::DataSynchronizer.new(semester: "2021.2", imported_by: admin).call

    post imports_sigaa_path, params: { sigaa_sync: { semester: "2021.2" } }

    expect(response).to redirect_to(imports_sigaa_path)
    follow_redirect!
    expect(response.body).to include("A base de dados já está atualizada com o SIGAA para este período.")
  end

  it "restringe acesso a administradores" do
    participant = create(:user)
    login_as(participant)

    get imports_sigaa_path

    expect(response).to redirect_to(root_path)
  end
end
