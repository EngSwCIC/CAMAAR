##
# Classe Controller que define as ações capazes de serem feitas para manipular um Cclass
# por meio da aplicação

class CclassesController < ApplicationController
  ##
  # Método que renderiza as +CClasses+ de um membro cujo +id+ foi passado
  # por parâmetro (+params+).
  #
  # Caso o membro identificado por +params[:member_id]+ não seje encontrado,
  # uma resposta com status +not_found (404)+ é renderizada. Caso o membro seja
  # encontrado, renderiza uma resposta contendo as +CClasses+ e +Subjects+ desse membro,
  # juntamente com o status +ok (200)+.

  def index
    head :not_found and return if params[:member_id].nil?
    @member = Member.find(params[:member_id])

    if !@member.blank?
      @cclasses = []
      for enrollment in @member.enrollments do
        @cclasses.push(enrollment.cclass)
      end

      render json: @cclasses, include: :subject
    else
      head :not_found
    end
  end
end
