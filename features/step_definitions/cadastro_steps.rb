Dado('que estou na página de gerenciamento') do
  # expect(page).to have_current_path(gerenciamento_path)
  # implementar quando o nome da rota for determinado
end

Dado('que eu importei os dados do SIGAA com sucesso') do
  # implementar a partir da feature de importar dados
end

Então('o e-mail de usuário {string} está cadastrado no sistema com senha indefinida') do |email|
  # implementar quando definir models
end

Então('um email de definição de senha é enviado para o email {string}') do |email|
  # implementar quando definir models (vai ser um método do model)
end