# encoding: utf-8

Dado(/^estou na página (?:de )?"([^"]*)"$/) do |pagina|
  case pagina
  when 'Gerenciamento - Usuários'
    visit admin_imports_path
  when 'página de login'
    visit login_path
  when 'Avaliações'
    visit avaliacoes_path
  when 'Gerenciamento'
    visit admin_management_path if respond_to?(:admin_management_path)
  when 'Gerenciamento - Resultados'
    visit admin_results_path if respond_to?(:admin_results_path)
  when 'Gerenciamento - Turmas'
    visit admin_classes_path if respond_to?(:admin_classes_path)
  when 'Gerenciamento - Formulários Ativos'
    visit admin_forms_path if respond_to?(:admin_forms_path)
  when 'Gerenciamento - Templates'
    visit admin_templates_path if respond_to?(:admin_templates_path)
  when 'Home', 'página inicial'
    visit home_path
  else
    visit root_path
  end
end

Quando(/^clico no botão "([^"]*)"$/) do |botao|
  click_link_or_button botao
end
