class PagesController < ApplicationController

  def home_dicente
    @dicente = Dicente.find_by(user_id: current_user.id)
    if @dicente.present?
      @turmas = TurmasDicente.where(dicente_id: @dicente.id).includes(:formularios)
      if !@turmas.present?
        @turmas = []
      end
    else
      @turmas = []
    end
  end

  def home_docente
    @docente = Docente.find_by(user_id: current_user.id)
    if @docente.present?
      # Busca todas as classes do docente incluindo os formulários associados
      @turmas = Turma.where(docente_id: @docente.id).includes(:formularios)
      @turmas = [] unless @turmas.present?

      # Busca os templates, tipos e qualquer outra informação necessária
      @templates = Template.where(docente_id: @docente.id)
      @tipos = Tipo.where(docente_id: @docente.id)

      # Aqui você pode acessar os formulários através das classes
      # Exemplo de como acessar os formulários de cada classe:
      @formularios = @classes.flat_map { |classe| classe.formularios }
    else
      @turmas = []
      @templates = []
      @tipos = []
      @formularios = []
    end
  end
end
