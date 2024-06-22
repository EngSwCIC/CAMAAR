class ResultadosController < ApplicationController
  def new
    @formulario = Formulario.find(params[:formulario_id])
    @resultado = Resultado.new(formulario: @formulario)
    @resultado.respostas.build # Constrói as respostas vazias para todas as questões do formulário
  end

  def create
    @resultado = Resultado.new(resultado_params)

    if @resultado.save
      @resultado.calcular_nota
      @resultado.save # Salva novamente para persistir a nota calculada
      redirect_to @resultado, notice: 'Resultado foi criado com sucesso.'
    else
      @formulario = @resultado.formulario
      render :new
    end
  end

  private

  def resultado_params
    params.require(:resultado).permit(:dicente_id, :formulario_id, respostas_attributes: [:id, :questao_id, :conteudo])
  end
end
