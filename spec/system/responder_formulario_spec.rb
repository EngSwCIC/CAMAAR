require 'rails_helper'

RSpec.describe "Responder formulário", type: :system do
  before do
    driven_by(:rack_test)

    @aluno = User.create!(nome: "Aluno", email: "aluno@teste.com", password: "password123",
                          matricula: "190000000", perfil: "discente")
    @template = Template.create!(
      nome: "Avaliação",
      questions_attributes: [{ enunciado: "Como foi a disciplina?", tipo: "discursiva" }]
    )
    @turma = Turma.create!(code: "CIC0105", name: "ENG SW", class_code: "TA", semester: "2021.2")
    Enrollment.create!(user: @aluno, turma: @turma, role: "discente")
    @formulario = Formulario.create!(template: @template, turma: @turma, titulo: "Formulário 1")

    login_as(@aluno, scope: :user)
  end

  it "lista formulários pendentes e permite responder" do
    visit formularios_path
    expect(page).to have_text("Formulário 1")

    click_link "Responder"

    question = @template.questions.first
    fill_in "respostas[#{question.id}]", with: "Foi ótima"
    click_button "Enviar Respostas"

    expect(page).to have_text("Respostas enviadas. Obrigado!")
    expect(@formulario.respostas.count).to eq(1)
    expect(@formulario.respondido_por?(@aluno)).to be true
  end

  it "impede responder duas vezes" do
    Resposta.create!(formulario: @formulario, user: @aluno,
                     question: @template.questions.first, valor: "Já respondi")

    visit formulario_path(@formulario)
    expect(page).to have_text("Você já respondeu este formulário.")
  end
end
