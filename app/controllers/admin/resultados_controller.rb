class Admin::ResultadosController < Admin::BaseController
  def index
    @formularios = Formulario.includes(:turma, :template).all
  end

  def show
    @formulario = Formulario.find(params[:id])
  end

  def exportar_csv
    @formulario = Formulario.includes(questoes: { respostas: { discente: :pessoa } }).find(params[:id])
    
    if @formulario.status != 'fechado'
      redirect_to admin_resultados_path, alert: "Relatórios só podem ser gerados para avaliações encerradas."
      return
    end

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Aluno", "Matrícula", "Questão", "Resposta"]
      @formulario.questoes.each do |questao|
        questao.respostas.each do |resposta|
          csv << [resposta.discente.pessoa.nome, resposta.discente.matricula, questao.enunciado, resposta.conteudo]
        end
      end
    end
    send_data csv_data, filename: "relatorio_turma_#{@formulario.turma.codigo}.csv", type: "text/csv"
  end
end