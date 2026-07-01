require 'csv'

# Responsável pelas regras de negócio relacionadas às avaliações:
# listagem, submissão de respostas, resultados e exportação em CSV.
class AvaliacaoService

  CSV_HEADERS = ['Aluno', 'Questão', 'Resposta'].freeze


  # Retorna as avaliações visíveis para o usuário informado.
  #
  # Recebe +user+ (instância de +User+).
  # Retorna todas as avaliações se o usuário for admin, ou apenas as
  # avaliações pendentes das turmas do discente caso contrário.
  # Não altera o banco de dados.
  def self.avaliacoes_para(user)
    return avaliacoes_admin if user.admin?

    avaliacoes_discente(user)
  end

  # Retorna todas as avaliações com template e turma pré-carregados.
  #
  # Não recebe argumentos. Retorna um +ActiveRecord::Relation+ de
  # +Avaliacao+. Não altera o banco de dados.
  def self.avaliacoes_admin
    Avaliacao.includes(:template, :turma).all
  end

  # Retorna as avaliações pendentes das turmas do discente informado.
  #
  # Recebe +user+ (instância de +User+). Retorna um +ActiveRecord::Relation+
  # de +Avaliacao+ filtradas por turmas do usuário, do tipo discente e
  # ainda não respondidas. Não altera o banco de dados.
  def self.avaliacoes_discente(user)
    turma_ids = user.turmas.pluck(:id)

    Avaliacao.includes(:template, turma: :disciplina)
             .para_discentes
             .where(turma_id: turma_ids)
             .nao_respondidas_por(user)
  end

  # Verifica se o usuário já respondeu a avaliação informada.
  #
  # Recebe +avaliacao+ (instância de +Avaliacao+) e +user+ (instância
  # de +User+). Retorna +true+ se já existe registro de +Resposta+ para
  # o par avaliação/usuário, +false+ caso contrário.
  # Não altera o banco de dados.
  def self.ja_respondeu?(avaliacao, user)
    Resposta.exists?(
      avaliacao: avaliacao,
      user: user
    )
  end

  # Processa a submissão das respostas de uma avaliação.
  #
  # Recebe +:avaliacao+ (instância de +Avaliacao+), +:user+ (instância
  # de +User+) e +:respostas_params+ (hash com questao_id => texto).
  # Possui três possibilidades de retorno:
  # - +:ja_respondeu+ se o usuário já respondeu anteriormente;
  # - +true+ se todas as respostas forem válidas e salvas com sucesso;
  # - +false+ se alguma resposta for inválida ou não puder ser salva.
  # Efeito colateral: persiste registros de +Resposta+ no banco de dados
  # em caso de sucesso.
  def self.submeter_respostas(avaliacao:, user:, respostas_params:)
    return :ja_respondeu if ja_respondeu?(avaliacao, user)

    respostas = build_respostas(
      avaliacao: avaliacao,
      user: user,
      respostas: respostas_params
    )

    respostas.any? &&
      respostas.all?(&:valid?) &&
      respostas.all?(&:save)
  end

  # Constrói um array de instâncias de +Resposta+ em memória.
  #
  # Recebe +:avaliacao+, +:user+ e +:respostas+ (hash com
  # questao_id => texto, podendo ser +nil+). Retorna um +Array+ de
  # +Resposta+ não persistidos. Não altera o banco de dados.
  def self.build_respostas(avaliacao:, user:, respostas:)
    (respostas&.to_unsafe_h || {}).map do |questao_id, texto|
      nova_resposta(
        avaliacao,
        user,
        questao_id,
        texto
      )
    end
  end

  # Instancia um único objeto +Resposta+ em memória.
  #
  # Recebe +avaliacao+ (instância de +Avaliacao+), +user+ (instância de
  # +User+), +questao_id+ (inteiro) e +texto+ (string). Retorna uma
  # instância de +Resposta+ não persistida. Não altera o banco de dados.
  def self.nova_resposta(avaliacao, user, questao_id, texto)
    Resposta.new(
      avaliacao: avaliacao,
      user: user,
      questao_id: questao_id,
      texto: texto
    )
  end

  # Retorna as questões do template da avaliação com respostas pré-carregadas.
  #
  # Recebe +avaliacao+ (instância de +Avaliacao+). Retorna um
  # +ActiveRecord::Relation+ de +Questao+ com +:respostas+ incluídas.
  # Não altera o banco de dados.
  def self.questoes_resultado(avaliacao)
    avaliacao
      .template
      .questoes
      .includes(:respostas)
  end

  # Retorna o número de respondentes únicos de uma avaliação.
  #
  # Recebe +avaliacao+ (instância de +Avaliacao+). Retorna um +Integer+
  # com a contagem de +user_id+ distintos nas respostas da avaliação.
  # Não altera o banco de dados.
  def self.total_respostas(avaliacao)
    Resposta.where(avaliacao: avaliacao)
            .select(:user_id)
            .distinct
            .count
  end


  # Gera o conteúdo CSV das respostas de uma avaliação.
  #
  # Recebe +avaliacao+ (instância de +Avaliacao+). Retorna +nil+ se não
  # houver respostas, ou uma +String+ com o conteúdo CSV em caso de sucesso.
  # Não altera o banco de dados.
  def self.exportar_csv(avaliacao)
    respostas = respostas_da_avaliacao(avaliacao)
    return nil if respostas.empty?

    gerar_csv(respostas)
  end

  # Busca todas as respostas de uma avaliação.
  #
  # Recebe +avaliacao+ (instância de +Avaliacao+). Retorna um
  # +ActiveRecord::Relation+ de +Resposta+. Não altera o banco de dados.
  def self.respostas_da_avaliacao(avaliacao)
    Resposta.where(avaliacao: avaliacao)
  end

  # Gera uma string CSV com cabeçalho e linhas de resposta.
  #
  # Recebe +respostas+ (+ActiveRecord::Relation+ de +Resposta+).
  # Retorna uma +String+ no formato CSV com colunas Aluno, Questão e
  # Resposta. Não altera o banco de dados.
  def self.gerar_csv(respostas)
    CSV.generate(headers: true) do |csv|
      csv << CSV_HEADERS
      adicionar_respostas_csv(csv, respostas)
    end
  end

  # Itera sobre as respostas e adiciona cada linha ao objeto CSV.
  #
  # Recebe +csv+ (objeto +CSV+) e +respostas+ (+ActiveRecord::Relation+
  # de +Resposta+). Não retorna valor relevante. Não altera o banco de dados.
  def self.adicionar_respostas_csv(csv, respostas)
    respostas.includes(:user, :questao).each do |resposta|
      csv << linha_csv(resposta)
    end
  end

  # Formata uma resposta como array para inserção no CSV.
  #
  # Recebe +resposta+ (instância de +Resposta+). Retorna um +Array+ com
  # nome do aluno, enunciado da questão e texto da resposta.
  # Não altera o banco de dados.
  def self.linha_csv(resposta)
    [
      resposta.user.name,
      resposta.questao.enunciado,
      resposta.texto
    ]
  end

end