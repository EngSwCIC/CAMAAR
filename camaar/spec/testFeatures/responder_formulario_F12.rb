require 'rails_helper'

RSpec.describe 'Processo de responder um formulário', type: :system do
  it 'responde o questionário com sucesso ' do
    visit '/avaliacoes'
    find('#card-0').click
    choose('questao-radio', option: 'Bom')
    fill_in('questão 2', with: "Resultado")
    click_button('enviar')

    expect(page).to have_content('Questionário respondido com sucesso')
  end

  it 'falha pois o questionário foi respondido de forma incompleta' do
    visit '/avaliacoes'
    find('#card-0').click
    choose('questao-radio', option: 'Bom')
    click_button('enviar')

    expect(page).to have_content('Erro ao enviar questionário: Todas as perguntas devem ser respondidas')
  end

  it 'avisa que um usuário não está matriculado em uma turma' do
    visit '/avaliacoes'

    expect(page).to have_content('Usuário não matriculado em nenhuma turma. Não há questionários para responder')
  end

  # TODO: MANIPULAÇÃO DO SERVIDOR A FIM DE CAUSAR UM ERRO
  it 'erro ao submeter questionário' do
    visit '/avaliacoes'
    find('#card-0').click
    choose('questao-radio', option: 'Bom')
    fill_in('questão 2', with: "Resultado")
    click_button('enviar')
  end

end