class PagesController < ApplicationController

  def home_dicente
    @dicente = Dicente.find_by(user_id: current_user.id)
    if @dicente.present?
      @classes = ClassesDicente.where(dicente_id: @dicente.id).includes(:formularios)
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
    @docente = Docente.find_by(user_id: current_user.id)
    if @docente.present?
      # Busca todas as classes do docente incluindo os formulários associados
      @classes = Classe.where(docente_id: @docente.id).includes(:formularios)
      @classes = [] unless @classes.present?

      # Busca os templates, tipos e qualquer outra informação necessária
      @templates = Template.where(docente_id: @docente.id)
      @tipos = Tipo.where(docente_id: @docente.id)

      # Aqui você pode acessar os formulários através das classes
      # Exemplo de como acessar os formulários de cada classe:
      @formularios = @classes.flat_map { |classe| classe.formularios }
    else
      @classes = []
      @templates = []
      @tipos = []
      @formularios = []
    end
  end
end
