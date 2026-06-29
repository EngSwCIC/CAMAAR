require 'rails_helper'


RSpec.describe "Cadastrar usuário com dados válidos", type: :system do
  before do
    # has_firefox = system('which firefox > /dev/null 2>&1 || where firefox > /dev/null 2>&1')
    driven_by(:rack_test)
    # driven_by(:selenium, using: has_firefox ? :headless_firefox : :headless_chrome)

    @admin = User.create!(
      nome: "Administrador",
      email: "admin@camaar.com",
      matricula: "000000001",
      perfil: "Administrador",
      password: "123456"
    )

    @arquivo_teste_json = 'class_members.json'
  end

  it "logar no perfil de Administrador" do
  visit '/login'

  fill_in 'E-mail ou matrícula', with: @admin.email
  fill_in 'Senha', with: @admin.password

  click_button 'Entrar'

  visit '/admin'

  expect(page).to have_current_path('/admin')
  end

  it "Acessar a opção de Gerenciamento" do
    visit '/login'

    fill_in 'E-mail ou matrícula', with: @admin.email
    fill_in 'Senha', with: @admin.password

    click_button 'Entrar'
    visit '/admin'

    expect(page).to have_link("Gerenciamento")
    click_link 'Gerenciamento'
    expect(page).to have_content("Painel de Gerenciamento")
  end

  it "Clicar na opção de importar dados" do
    visit '/login'

    fill_in 'E-mail ou matrícula', with: @admin.email
    fill_in 'Senha', with: @admin.password

    click_button 'Entrar'
    visit '/admin'

    expect(page).to have_link("Gerenciamento")
    click_link 'Gerenciamento'

    @import_usuarios = 'Importar Dados'
    expect(page).to have_content(@import_usuarios) # mudar para have_link ou have_button dependendo do tipo de elemento
  
    find('label', text: @import_usuarios).click

  end

  it "Importar e selecionar o arquivo json" do
    visit '/login'

    fill_in 'E-mail ou matrícula', with: @admin.email
    fill_in 'Senha', with: @admin.password

    click_button 'Entrar'
    visit '/admin'

    click_link 'Gerenciamento'

    @import_usuarios = 'Importar Dados'
    expect(page).to have_content(@import_usuarios) # mudar para have_link ou have_button dependendo do tipo de elemento
  
    find('label', text: @import_usuarios).click

    @arquivo_json = Rails.root.join('class_members.json')

    attach_file('arquivo_json', @arquivo_json, visible: :any)
    
    click_button('botao_enviar_oculto', visible: false)

    #div_arquivo = find('#secao_importa').trigger('submit')
    #expect(page).to_not have_content('Nenhuma turma cadastrada.')
    

  end

  it "Dados validos de importação" do
    visit '/login'

    fill_in 'E-mail ou matrícula', with: @admin.email
    fill_in 'Senha', with: @admin.password

    click_button 'Entrar'
    visit '/admin'

    click_link 'Gerenciamento'

    @import_usuarios = 'Importar Dados'
  
    find('label', text: @import_usuarios).click

    @arquivo_json = Rails.root.join('class_members.json')
    attach_file('arquivo_json', @arquivo_json, visible: :any)
    click_button('botao_enviar_oculto', visible: false)

    # Validação pelo registro no banco de dados

    expect(Turma.count).to be > 0
    expect(Discente.count).to be > 0
    expect(Docente.count).to be > 0
  end

end
