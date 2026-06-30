require 'rails_helper'

RSpec.describe "Resultados e relatório do formulário", type: :system do
  before do
    driven_by(:rack_test)

    @admin = User.create!(nome: "Admin", email: "admin@teste.com", password: "password123",
                          matricula: "100000000", perfil: "docente")
    @aluno = User.create!(nome: "Aluno", email: "aluno@teste.com", password: "password123",
                          matricula: "190000000", perfil: "discente")
    @template = Template.create!(
      nome: "Avaliação",
      questions_attributes: [ { enunciado: "Como foi a disciplina?", tipo: "discursiva" } ]
    )
    @turma = Turma.create!(code: "CIC0105", name: "ENG SW", class_code: "TA", semester: "2021.2")
    Enrollment.create!(user: @aluno, turma: @turma, role: "discente")
    @formulario = Formulario.create!(template: @template, turma: @turma, titulo: "Formulário 1")
    Resposta.create!(formulario: @formulario, user: @aluno,
                     question: @template.questions.first, valor: "Foi ótima")

    login_as(@admin, scope: :user)
  end

  it "mostra os resultados para o docente (issue #13)" do
    visit formulario_path(@formulario)

    expect(page).to have_text("Resultados — Formulário 1")
    expect(page).to have_text("Foi ótima")
    expect(page).to have_text("1 de 1")
  end

  it "gera o relatório em CSV (issue #6)" do
    visit relatorio_formulario_path(@formulario, format: :csv)

    expect(page.body).to include("Questão")
    expect(page.body).to include("Como foi a disciplina?")
    expect(page.body).to include("Foi ótima")
  end

  it "garante que o aluno não veja os resultados de outros alunos" do
    logout(:user)
    login_as(@aluno, scope: :user)

    visit formulario_path(@formulario)

    # O aluno deve ver apenas a confirmação de que respondeu,
    # e NÃO deve ver o texto "Resultados" ou as respostas de outros.
    expect(page).not_to have_text("Resultados")
    expect(page).not_to have_text("Foi ótima")
  end
end
