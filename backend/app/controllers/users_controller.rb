##
# Classe da controler do cadastro de usuarios
class UsersController < ApplicationController
  ##
  # Metodo respond_with
  # 
  # Responsavel por decidir qual qual valor de user retornar e qual mensagem deve ser apresentada ao usuario.
  # Dependnedo do resultado ela chama o register_failed ou o register_success 
  #
  # Parametros: resource, que representa o user que esta sendo tratado
  #
  # Retorno: respond_to :json
  #
  # Transformacao: Nenhuma
  #
  respond_to :json
  private
  def respond_with(resource)
    register_success(resource) && return if resource != nil

    register_failed(resource)
  end
  
  ##
  # Metodo register_success
  # 
  # Responsavel por retornar os dados de um registro bem  sucedido
  #
  # Parametros: resource, que representa o user que esta sendo tratado
  #
  # Retorno: json para o front end
  #
  # Transformacao: Nenhuma
  #
  def register_success(resource)
    render json: {
      message: 'Cadastrado com sucesso',
      user: resource
    }, status: :ok
  end
  
  ##
  # Metodo register_failed
  # 
  # Responsavel por retornar os dados de um registro mal  sucedido
  #
  # Parametros: resource, que representa o user que esta sendo tratado
  #
  # Retorno: json para o front end
  #
  # Transformacao: Nenhuma
  #
  def register_failed(resource)
    render json: {
      message: 'Error ao cadastrar usuario',
      user: resource
    }, status: :ok
  end
  
  ##
  # Construtor da classe
  # 
  # Recebe os dados para realizar a consulta no banco de dados. Caso exista o membro, mas
  # nao um usuario ele cria um usuario para o membro no banco de dados
  #
  # Parametros: Dados de senha e email recebidos do front end
  #
  # Retorno: user
  #
  # Transformacao: Cria um user para um member no ba
  #
  public
  def create
      email = params[:email_pessoa]
      senha = User.new(:password => params[:senha_pessoa]).encrypted_password
      if Member.exists?(:email=> email) && !User.exists?(:email=> email)
            member = Member.find_by(:email => email)
            user = User.create(email: email,encrypted_password: senha, created_at: params[:created_at_pessoa], updated_at: params[:updated_at_pessoa], member: member)
      end
      respond_with(user)
  end
  end
