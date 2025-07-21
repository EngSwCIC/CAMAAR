class HomeController < ApplicationController
  def index
    pessoa = current_pessoa
    puts "PESSOA: #{pessoa}"

    if pessoa.nil?
      redirect_to new_session_path, alert: "Você precisa estar logado."
      return
    end

    funcoes = pessoa.cargos.pluck(:funcao)
    puts "Funções do usuário: #{funcoes.inspect}"
    case
    when funcoes.include?(0)
      redirect_to admin_gerenciamento_path
    when funcoes.include?(1)
      redirect_to user_avaliacoes_path
    when funcoes.include?(2)
      redirect_to user_avaliacoes_path
    else
      redirect_to root_path, alert: "Você não tem permissão de acesso."
    end
  end
end