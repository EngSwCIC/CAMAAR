# Exibe resultados de formulários e permite exportação de relatórios em CSV.
class Admin::ResultadosController < Admin::BaseController
  # Lista todos os formulários com suas turmas e templates associados.
  #
  # Efeito colateral: atribui +@formularios+ com todos os formulários,
  # pré-carregando turma e template.
  def index
    @formularios = Formulario.includes(:turma, :template).all
  end

  # Exibe os resultados de um formulário específico.
  #
  # Parâmetros: +:id+ via params — ID do formulário.
  # Efeito colateral: atribui +@formulario+ com o registro encontrado.
  def show
    @formulario = Formulario.find(params[:id])
  end

  # Exporta os resultados de um formulário encerrado como arquivo CSV.
  #
  # Parâmetros: +:id+ via params — ID do formulário.
  # Retorno: envia arquivo CSV com nome baseado no código da turma.
  # Efeito colateral: redireciona para +admin_resultados_path+ com alerta
  # se o formulário ainda estiver aberto (relatório não disponível).
  def exportar_csv
    @formulario = Formulario.includes(questoes: { respostas: { discente: :pessoa } }).find(params[:id])

    if @formulario.status != 'fechado'
      redirect_to admin_resultados_path, alert: "Relatórios só podem ser gerados para avaliações encerradas."
      return
    end

    send_data gerar_csv(@formulario), filename: "relatorio_turma_#{@formulario.turma.codigo}.csv", type: "text/csv"
  end

  private

  # Gera o conteúdo CSV com as respostas de todos os discentes.
  #
  # Parâmetros: +formulario+ — instância de +Formulario+ com questões e
  # respostas pré-carregadas.
  # Retorno: String com o CSV gerado, incluindo cabeçalho.
  def gerar_csv(formulario)
    CSV.generate(headers: true) do |csv|
      csv << ["Aluno", "Matrícula", "Questão", "Resposta"]
      formulario.questoes.each { |questao| linhas_da_questao(questao).each { |linha| csv << linha } }
    end
  end

  # Constrói as linhas CSV para uma questão, uma por resposta recebida.
  #
  # Parâmetros: +questao+ — instância de +Questao+ com respostas e
  # discentes pré-carregados.
  # Retorno: Array de Arrays, cada um com [nome, matrícula, enunciado,
  # conteúdo da resposta].
  def linhas_da_questao(questao)
    questao.respostas.map do |resposta|
      [resposta.discente.pessoa.nome, resposta.discente.matricula, questao.enunciado, resposta.conteudo]
    end
  end
end
