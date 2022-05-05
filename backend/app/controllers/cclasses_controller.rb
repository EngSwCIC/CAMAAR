class CclassesController < ApplicationController

  # TODO: Validar o usuário logado usando o token, então trocar params[:member_id] pelo current_user.id (remover tambem o parametro da rota)

  ##
  # Método para obter uma lista com todas as classes que um membro faz parte
  #
  # O método recebe como parâmetro apenas o +member_id+ (int), no entanto
  # o ideal seria validar o usuário que está logado e pegar o id dele
  #
  # Método não retorna nada, mas renderiza um json com todas as classes que
  # o membro faz parte, cada uma mostrando as colunas +id+, +code+, +semester+,
  # +time+ e +subject+; esta última mostrando apenas as colunas +name+ e +code+.
  #
  # Levanta um erro caso não exista nenhum membro com o id passado como parâmetro e
  # renderiza uma mensagem como um json informando que não foi possível encontrar o membro

  def member_classes
    classes = Member.find(params[:member_id]).cclasses
    render json: classes, only: %w[id code semester time], include: { subject: { only: %w[code name] } }, status: :ok
  rescue StandardError
    render json: { message: "Membro não encontrado" } , status: :not_found
  end
end
