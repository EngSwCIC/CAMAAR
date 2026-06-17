require 'rails_helper'
require 'csv'

RSpec.describe 'Relatório do Administrador', type: :feature do
  def login_as_admin
    User.create!(
      email: 'admin.teste@unb.br',
      matricula: '000000001',
      password: 'senhaAdmin',
      password_confirmation: 'senhaAdmin',
      role: 'admin',
      nome: 'Admin Teste'
    )

    visit login_path
    fill_in 'email', with: 'admin.teste@unb.br'
    fill_in 'password', with: 'senhaAdmin'
    click_button 'Entrar'
  end

  def create_turma_com_respostas
    @disciplina = Disciplina.create!(code: 'CIC0001', name: 'Engenharia de Software')
    @docente = User.create!(
      email: 'prof.fulano@unb.br',
      matricula: '111000001',
      password: 'senhaDocente',
      password_confirmation: 'senhaDocente',
      role: 'docente',
      nome: 'Prof. Fulano',
      departamento: 'CIC'
    )
    @turma = Turma.create!(classCode: 'T01', semester: '2024.1', time: '10:00', disciplina: @disciplina)
    @turma.docentes << @docente

    @template = Template.create!(name: 'Avaliação Padrão')
    @questao1 = @template.questions.create!(kind: 'radio', text: 'Como você avalia a didática?')
    @questao2 = @template.questions.create!(kind: 'text', text: 'Comentários adicionais')

    @form = Form.create!(template: @template, start_date: 1.day.ago, end_date: 1.day.from_now)
    @form.turmas << @turma

    @discente = User.create!(
      email: 'discente@gmail.com',
      matricula: '190084010',
      password: 'senhaDicente',
      password_confirmation: 'senhaDicente',
      role: 'discente',
      nome: 'Discente Teste'
    )
    @discente.turmas << @turma

    FormResponse.create!(
      form: @form,
      user: @discente,
      turma: @turma,
      answers: [
        { question_id: @questao1.id, value: 'Muito bom' },
        { question_id: @questao2.id, value: 'Ótimo monitor' }
      ]
    )
  end

  scenario 'visualiza listagem de turmas com resultados disponíveis' do
    login_as_admin
    create_turma_com_respostas

    visit admin_results_path

    expect(page).to have_selector('.turma-card')
    within('.turma-card', match: :first) do
      expect(page).to have_selector('.turma-nome')
      expect(page).to have_selector('.turma-semestre')
      expect(page).to have_selector('.turma-professor')
    end
  end

  scenario 'baixa CSV com resultados de uma turma' do
    login_as_admin
    create_turma_com_respostas

    visit admin_results_path
    within('.turma-card', text: 'Engenharia de Software') do
      click_on 'Engenharia de Software'
    end
    click_button 'Baixar CSV'

    expect(page.response_headers['Content-Type']).to include('text/csv')
    expect(page.response_headers['Content-Disposition']).to include('attachment')
    expect(page.response_headers['Content-Disposition']).to include('.csv')

    headers = CSV.parse(page.body, headers: true).headers
    expect(headers).to include('Turma', 'Discente', 'Questão', 'Resposta')

    rows = CSV.parse(page.body, headers: true)
    expect(rows.size).to be >= 1
    rows.each do |row|
      expect(row['Discente']).not_to be_blank
      expect(row['Resposta']).not_to be_blank
    end
  end
end
