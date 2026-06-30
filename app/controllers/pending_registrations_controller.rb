##
# Definição de senha do participante importado via SIGAA. O cadastro só é concluído (vira User) quando o participante define a senha pelo link.
class PendingRegistrationsController < ApplicationController
  ##
  # a. Descrição: Redireciona o usuário a se registrar para a página de definição de senha.
  # b. Argumentos: Recebe 'token' (String) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Atribui a variável @pending com o registro pendente encontrado e redireciona o usuário para a página de definição de senha, caso seja o 1° acesso.
  def edit
    @pending = PendingRegistration.find_by(token: params[:token])
    redirect_to root_path, alert: "Link inválido" if @pending.nil?
  end

  ##
  # a. Descrição: Faz a atualização da senha do participante importado via SIGAA.
  # b. Argumentos: Recebe 'token' (String) e 'senha' (String) como parâmetros.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria um novo usuário com os dados do participante pendente, atribuindo a senha definida, e redireciona o usuário para a página de listagem de usuários.
  def update
    @pending = PendingRegistration.find_by(token: params[:token])
    redirect_to root_path, alert: "Link inválido" and return if @pending.nil?

    User.create!(atributos_do_usuario(@pending, params[:senha].to_s))
    @pending.destroy

    redirect_to users_path, notice: "Cadastro concluído com sucesso."
  end

  private

  ##
  # a. Descrição: Monta o hash de atributos do novo usuário a partir do registro pendente.
  # b. Argumentos: Recebe 'pending' (PendingRegistration) e 'senha' (String).
  # c. Retorno: Retorna um Hash com os atributos a serem usados na criação do usuário.
  # d. Efeitos colaterais: Nenhum.
  def atributos_do_usuario(pending, senha)
    {
      email: pending.email,
      nome: pending.nome.presence || pending.email.split("@").first,
      matricula: pending.matricula.presence || gerar_matricula(pending),
      perfil: pending.perfil.presence || "discente",
      password: senha,
      password_confirmation: senha
    }
  end

  # Gera uma matrícula fictícia para o participante pendente, caso não tenha sido fornecida.
  def gerar_matricula(pending)
    "90#{pending.id.to_s.rjust(7, '0')}"
  end
end
