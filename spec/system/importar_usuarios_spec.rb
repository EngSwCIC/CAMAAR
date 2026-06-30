require 'rails_helper'

RSpec.describe "Importação de Usuários via CSV", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "importa os usuários com sucesso através do formulário" do
    visit new_user_path

    attach_file 'file', Rails.root.join('db', 'amostra_sigaa.csv')

    click_button 'Importar e Enviar Convites'

    # Após importar, redireciona para a home (root), que lista os usuários.
    expect(current_path).to eq(root_path)
    expect(page).to have_text("Usuários importados e convites enviados com sucesso!")

    expect(page).to have_text("Lucas Aluno")
    expect(page).to have_text("Professor Roberto")
  end

  it "exibe erro quando o arquivo enviado é inválido ou vazio" do
    visit new_user_path

    click_button 'Importar e Enviar Convites'

    expect(page).to have_text("Nenhum arquivo selecionado")
    expect(current_path).to eq(root_path)
  end
end
