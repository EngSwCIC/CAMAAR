class RespostasController < ApplicationController
  def create
    @resposta = Resposta.new(resposta_params)

    if @resposta.save
      # Lógica adicional, por exemplo, redirecionar para a próxima questão ou para a página de confirmação
    else
      # Lógica para lidar com falhas na criação da resposta
    end
  end

  private

  def resposta_params
    params.require(:resposta).permit(:resultado_id, :questao_id, :conteudo)
  end
end
