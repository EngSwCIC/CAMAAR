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
    when 'User Camaar'
      '/users/page'
    when 'Root'
      '/'
    when 'Admin Camaar'
      '/admins/page'
    when 'Formulários'
      '/forms'
    when /Formulário (\d+)/
      "/forms/#{::Regexp.last_match(1)}"
    when 'Templates'
      '/templates'
    when 'Redefina sua Senha'
      '/admins/...'
    when 'Resultados'
      '/admins/resultados'
    when 'Login de Usuário'
      '/users/login'
    when 'Login de Admin'
      '/admins/login'
    when 'Novo Template'
      '/templates/create'
    when /Template (\d+)/
      "/templates/#{::Regexp.last_match(1)}/edit"
    when /Turmas do (\w+)/
      "/classes/#{::Regexp.last_match(1)}"
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = ::Regexp.last_match(1).split(/\s+/)
        send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
              "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
