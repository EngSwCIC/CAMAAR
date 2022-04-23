class CclassesController < ApplicationController

  # TODO: Validar o usuário logado usando o token, então trocar params[:member_id] pelo current_user.id (remover tambem o parametro da rota)
  def member_classes
    classes = Member.find(params[:member_id]).cclasses
    render json: classes, status: :ok
  rescue StandardError
    render json: { message: "Membro não encontrado" } , status: :not_found
  end
end
