require "rails_helper"

RSpec.describe "Importacao de Dados do SIGAA", type: :request do
  let!(:admin) { create(:user, :admin, department: create(:department, code: "CIC")) }

  it "exibe a tela de importacao para administradores autenticados" do
    login_as(admin)
    get imports_sigaa_path

    expect(response).to have_http_status(:success)
    expect(response.body).to include("Importacao de Dados do SIGAA")
    expect(response.body).to include("2021.2")
  end

  it "sincroniza os dados do SIGAA e exibe mensagem de conclusao" do
    login_as(admin)

    expect do
      post imports_sigaa_path, params: { sigaa_sync: { semester: "2021.2" } }
    end.to change(CourseClass, :count).by_at_least(1)
      .and change(User.participant, :count).by_at_least(1)

    expect(response).to redirect_to(imports_sigaa_path)
    follow_redirect!
    expect(response.body).to match(/Sincronizacao concluida\. \d+ novos registros adicionados e \d+ registros atualizados\./)
  end

  it "informa quando a base ja esta atualizada para o periodo" do
    login_as(admin)
    Sigaa::DataSynchronizer.new(semester: "2021.2", imported_by: admin).call

    post imports_sigaa_path, params: { sigaa_sync: { semester: "2021.2" } }

    expect(response).to redirect_to(imports_sigaa_path)
    follow_redirect!
    expect(response.body).to include("A base de dados ja esta atualizada com o SIGAA para este periodo.")
  end

  it "restringe acesso a administradores" do
    participant = create(:user)
    login_as(participant)

    get imports_sigaa_path

    expect(response).to redirect_to(root_path)
  end
end
