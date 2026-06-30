require "csv"

class ResultadosController < ApplicationController
  before_action :require_admin_for_resultados, only: [ :show, :relatorios ]

  # Lista todos os formulários existentes para os quais resultados podem ser avaliados.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view de listagem contendo a coleção de todos os formulários.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define a variável de instância +@formularios+.
  def index
    @formularios = Formulario.all
  end

  # Exibe os resultados agregados e comentários de um formulário de avaliação específico.
  #
  # <b>Parâmetros:</b>
  # * +params[:id]+ - O ID do formulário de avaliação (Integer/String).
  #
  # <b>Retorno:</b>
  # * Renderiza a view com gráficos de métricas e comentários textuais do formulário.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define +@formulario+, +@respostas+, +@mensagem_aviso+, +@perguntas_metricas+ e +@comentarios+.
  def show
    @formulario = Formulario.find(params[:id])
    @respostas = @formulario.respostas
    @mensagem_aviso = "Este formulário ainda não recebeu respostas" if @respostas.empty?

    @perguntas_metricas = []
    @comentarios = []

    @formulario.template.perguntas.each do |pergunta|
      process_pergunta(pergunta)
    end
  end

  # Exibe a lista de relatórios disponíveis para exportação.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view com todos os formulários para exportação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define a variável de instância +@formularios+.
  def relatorios
    @formularios = Formulario.all
  end

  # Gera e exporta um arquivo CSV contendo os dados brutos de respostas de uma avaliação.
  #
  # <b>Parâmetros:</b>
  # * +params[:id]+ ou +params[:formulario_id]+ - ID do formulário associado (Integer/String).
  # * +params[:turma_id]+ - Filtro opcional para limitar resultados a uma turma específica (Integer/String).
  #
  # <b>Retorno:</b>
  # * Envio de dados de download do arquivo CSV ou redirecionamento em caso de erro/sem dados.
  #
  # <b>Efeitos Colaterais:</b>
  # * Envia uma resposta HTTP do tipo file stream contendo o arquivo CSV compilado. Define mensagens no +flash+ caso bloqueado ou sem dados.
  def export_csv_resultado
    return if require_admin_export_access

    @formulario = Formulario.find(params[:id] || params[:formulario_id])
    template = @formulario.template
    formularios = filter_formularios(template.formularios)

    return if check_empty_responses(formularios)

    csv_data = generate_csv_data(formularios)
    send_csv_response(csv_data, template)
  end

  private

  # Separa e processa uma pergunta individual do template de acordo com o seu tipo.
  #
  # <b>Parâmetros:</b>
  # * +pergunta+ - Objeto +QuestaoTemplate+.
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Popula os arrays de instância +@perguntas_metricas+ ou +@comentarios+.
  def process_pergunta(pergunta)
    itens = RespostaItem.where(questao_template: pergunta, resposta: @respostas)
    if pergunta.tipo == "likert"
      @perguntas_metricas << process_likert_question(pergunta, itens)
    else
      @comentarios << process_text_question(pergunta, itens)
    end
  end

  # Calcula e estrutura as estatísticas agregadas para uma pergunta do tipo escala Likert.
  #
  # <b>Parâmetros:</b>
  # * +pergunta+ - Objeto +QuestaoTemplate+.
  # * +itens+ - Coleção de objetos +RespostaItem+.
  #
  # <b>Retorno:</b>
  # * Hash formatado contendo +:pergunta+, +:media+, +:distribuicao+ (percentual de votos de 1 a 5) e +:count+ (total de votos).
  def process_likert_question(pergunta, itens)
    valores = itens.pluck(:valor_numerico).compact

    {
      pergunta: pergunta,
      media: calcular_media(valores),
      distribuicao: calcular_distribuicao(valores),
      count: valores.size
    }
  end

  # Calcula a média aritmética de uma lista de valores numéricos de respostas.
  #
  # <b>Parâmetros:</b>
  # * +valores+ - Array de inteiros.
  #
  # <b>Retorno:</b>
  # * Float arredondado para uma casa decimal.
  def calcular_media(valores)
    valores.any? ? (valores.sum.to_f / valores.size).round(1) : 0.0
  end

  # Calcula a frequência percentual de cada nota (de 1 a 5) em um conjunto de respostas.
  #
  # <b>Parâmetros:</b>
  # * +valores+ - Array de inteiros representando as notas coletadas.
  #
  # <b>Retorno:</b>
  # * Hash mapeando as notas de 1 a 5 para seus respectivos percentuais (inteiros).
  def calcular_distribuicao(valores)
    (1..5).to_h do |num|
      count = valores.count(num)
      percentage = valores.any? ? (count.to_f / valores.size * 100).round : 0
      [ num, percentage ]
    end
  end

  # Extrai as respostas textuais não em branco para uma pergunta dissertativa.
  #
  # <b>Parâmetros:</b>
  # * +pergunta+ - Objeto +QuestaoTemplate+.
  # * +itens+ - Coleção de +RespostaItem+.
  #
  # <b>Retorno:</b>
  # * Hash contendo a pergunta e um array contendo os textos das respostas.
  def process_text_question(pergunta, itens)
    {
      pergunta: pergunta,
      respostas: itens.pluck(:valor_texto).reject(&:blank?)
    }
  end

  # Verifica e impede acesso à exportação caso o usuário logado não seja administrador.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se acesso negado com redirecionamento ativo, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Define flash de alerta e redireciona para a raiz.
  def require_admin_export_access
    unless logged_in? && current_user.perfil == "administrador"
      flash[:alert] = "Acesso negado. Apenas administradores podem gerar este relatório."
      redirect_to "/"
      return true
    end
    false
  end

  # Impede a geração caso não existam respostas registradas para a coleção de formulários.
  #
  # <b>Parâmetros:</b>
  # * +formularios+ - Coleção de objetos +Formulario+.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se não houver respostas suficientes, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Redireciona com alerta no +flash+ caso não existam dados.
  def check_empty_responses(formularios)
    if formularios.joins(:respostas).count == 0
      flash[:alert] = "Não há dados suficientes para gerar o relatório desta avaliação."
      redirect_to admin_relatorios_path
      return true
    end
    false
  end

  # Filtra a coleção de formulários aplicando restrição de turma se o parâmetro correspondente estiver presente.
  #
  # <b>Parâmetros:</b>
  # * +formularios+ - Coleção de objetos +Formulario+.
  #
  # <b>Retorno:</b>
  # * Coleção de +Formulario+ filtrada.
  def filter_formularios(formularios)
    params[:turma_id].present? ? formularios.where(turma_id: params[:turma_id]) : formularios
  end

  # Prepara e envia os dados do arquivo CSV como anexo para download.
  #
  # <b>Parâmetros:</b>
  # * +csv_data+ - String contendo o CSV codificado.
  # * +template+ - O template associado à avaliação para compor o nome do arquivo.
  #
  # <b>Retorno:</b>
  # * Envia a resposta HTTP de download de arquivo.
  #
  # <b>Efeitos Colaterais:</b>
  # * Dispara o download de arquivo no navegador do usuário e insere confirmação no +flash+.
  def send_csv_response(csv_data, template)
    safe_name = template.titulo.downcase.gsub(/[^a-z0-9]/, "_").squeeze("_")
    filename = "resultados_#{safe_name}.csv"
    flash[:notice] = "Relatório gerado com sucesso."
    send_data csv_data, filename: filename, type: "text/csv; charset=utf-8"
  end

  # Constrói a estrutura e o conteúdo do CSV de resultados compilando dados de turmas, disciplinas e respostas de alunos.
  #
  # <b>Parâmetros:</b>
  # * +formularios+ - Coleção de objetos +Formulario+.
  #
  # <b>Retorno:</b>
  # * String contendo os registros CSV compilados.
  def generate_csv_data(formularios)
    CSV.generate(headers: true, col_sep: ",", encoding: "UTF-8") do |csv|
      csv << [ "Matrícula", "Turma", "Disciplina", "Respostas" ]

      formularios.each do |form|
        form.respostas.each do |resp|
          next unless valid_turma_response?(resp, params[:turma_id])
          append_resposta_itens_to_csv(csv, form, resp)
        end
      end
    end
  end

  # Valida se a resposta do discente pertence à turma informada na filtragem.
  #
  # <b>Parâmetros:</b>
  # * +resp+ - Objeto +Resposta+.
  # * +turma_id_param+ - Parâmetro opcional de ID da turma (String/Integer).
  #
  # <b>Retorno:</b>
  # * Boolean.
  def valid_turma_response?(resp, turma_id_param)
    return true if turma_id_param.blank?
    resp.usuario.matriculas.pluck(:turma_id).include?(turma_id_param.to_i)
  end

  # Varre os itens de respostas individuais anexando-os como linhas no objeto CSV.
  #
  # <b>Parâmetros:</b>
  # * +csv+ - Instância do gerador de CSV.
  # * +form+ - Objeto +Formulario+ avaliado.
  # * +resp+ - Objeto +Resposta+.
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Adiciona novas linhas ao objeto acumulador do CSV.
  def append_resposta_itens_to_csv(csv, form, resp)
    aluno_turma = extract_aluno_turma(form, resp)
    matricula = resp.usuario.matricula || "Anônimo"

    resp.resposta_itens.each do |item|
      csv << [ matricula, aluno_turma.codigo_turma, aluno_turma.disciplina.nome, extract_item_value(item) ]
    end
  end

  # Localiza a turma em que o discente realizou a avaliação ou retorna a turma padrão do formulário.
  #
  # <b>Parâmetros:</b>
  # * +form+ - Objeto +Formulario+.
  # * +resp+ - Objeto +Resposta+.
  #
  # <b>Retorno:</b>
  # * Instância de +Turma+.
  def extract_aluno_turma(form, resp)
    resp.usuario.matriculas.find_by(turma_id: form.turma_id)&.turma || form.turma
  end

  # Recupera a nota numérica ou o texto correspondente a um item de resposta individual.
  #
  # <b>Parâmetros:</b>
  # * +item+ - Objeto +RespostaItem+.
  #
  # <b>Retorno:</b>
  # * String correspondente ao valor.
  def extract_item_value(item)
    item.questao_template.tipo == "likert" ? item.valor_numerico.to_s : item.valor_texto
  end

  # Filtro/before_action interno para restringir o acesso a resultados de avaliações a administradores.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * +nil+ se autorizado, ou redirecionamento em caso contrário.
  #
  # <b>Efeitos Colaterais:</b>
  # * Redireciona com alerta no +flash+ caso não seja administrador logado.
  def require_admin_for_resultados
    unless logged_in? && current_user.perfil == "administrador"
      flash[:alert] = "Acesso negado: Perfil não autorizado"
      redirect_to "/"
    end
  end
end
