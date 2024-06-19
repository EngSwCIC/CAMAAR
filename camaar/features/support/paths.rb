# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when "Root"
      "/"
    when "Forms"
      "/users/forms"
    when /Formulário (Aluno|Professor)/
      "/users/forms/#{1}/edit"
    when "Templates"
      "/admins/templates"
    when "Redefina sua Senha"
      "/admins/..."
    when "Redefinir Senha Usuario"
      "/users/recover-password/edit"
    when "Meu Departamento"
      "/admins/classes"
    when "User Camaar"
      "/users/forms"
    when "Cadastro de Usuário"
      "/users/register"
    when "Importar dados"
      "/admins/import"
    when "Admin Camaar"
      "/admins/page"
    when "Users Login"
      "/users/login"
    when "Admins Login"
      "/admins/login"
    when "New Template"
      template = Template.last
      %'/admins/templates/#{template.id}/edit'
    when "Add Question"
      template = Template.last
      %'/admins/templates/#{template.id}/template_questions/new'
    when /Template (\d+)/
      "/admins/templates/#{::Regexp.last_match(1)}/edit"
    when /Turmas do (\w+)/
      "/classes/#{::Regexp.last_match(1)}"
    when "Dispatch"
      "/admins/dispatch"
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = ::Regexp.last_match(1).split(/\s+/)
        send(path_components.push("path").join("_").to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
              "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
