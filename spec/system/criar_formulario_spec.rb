require 'rails_helper'

RSpec.describe "Criar formulário", type: :system do
  before do
    driven_by(:rack_test)

    @admin = User.create!(nome: "Admin", email: "admin@teste.com", password: "password123",
                          matricula: "100000000", perfil: "docente")
    @template = Template.create!(nome: "Avaliação de Disciplina")
    @turma = Turma.create!(code: "CIC0105", name: "ENG SW", class_code: "TA", semester: "2021.2")

    login_as(@admin, scope: :user)
  end

  it "cria um formulário para a turma escolhida" do
    visit new_formulario_path

    select "Avaliação de Disciplina", from: "template_id"
    check @turma.nome_completo
    click_button "Criar Formulário"

    expect(page).to have_text("Formulário criado com sucesso.")
    expect(Formulario.count).to eq(1)
    expect(Formulario.first.turma).to eq(@turma)
  end

  it "avisa quando nenhuma turma é selecionada" do
    visit new_formulario_path

    select "Avaliação de Disciplina", from: "template_id"
    click_button "Criar Formulário"

    expect(page).to have_text("Selecione um template e ao menos uma turma.")
    expect(Formulario.count).to eq(0)
  end
end
