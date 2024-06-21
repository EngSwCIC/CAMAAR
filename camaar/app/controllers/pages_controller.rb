class PagesController < ApplicationController

  def home_dicente
    dicente = Dicente.find_by(user_id: current_user.id)
    if dicente.present?
      @classes = ClassesDicente.where(dicente_id: dicente.id).includes(:formularios)
      if !@classes.present?
        @classes = []
      end

      #classes_dicentes = ClassesDicente.where(dicente_id: dicente.id)
      #@classes = Classe.where(id: classes_dicentes.pluck(:classe_id)).includes(:formularios)
    else
      @classes = []
      # Tratar o caso onde o dicente não foi encontrado para o current_user.id
    end
  end

  def home_docente

  end
end
