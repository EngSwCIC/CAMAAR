class LimparDadosService
  # Limpa todos os dados de usuários, turmas e formulários do banco,
  # preservando os registros de administradores e seus departamentos.
  #
  # Argumentos: nenhum.
  # Retorno: Hash — { success: true } quando concluído com êxito,
  #          { success: false, error: <mensagem> } em caso de erro.
  # Efeitos colaterais: apaga registros em múltiplas tabelas dentro de
  # uma transação com checagem de FK desabilitada (SQLite PRAGMA).
  def call
    conn = ActiveRecord::Base.connection
    # Necessário desabilitar a verificação de FK do SQLite para evitar
    # erro de constraints durante a limpeza em cascata.
    conn.execute("PRAGMA foreign_keys = OFF")

    ActiveRecord::Base.transaction { limpar_registros }

    { success: true }
  rescue StandardError => e
    { success: false, error: e.message }
  ensure
    conn.execute("PRAGMA foreign_keys = ON")
  end

  private

  # Coordena a limpeza completa: coleta os IDs a preservar e chama os
  # métodos responsáveis por cada grupo de tabelas.
  #
  # Argumentos: nenhum.
  # Retorno: nenhum.
  # Efeitos colaterais: dispara todas as deleções em ordem segura.
  def limpar_registros
    admin_usuario_ids, admin_depto_ids, admin_criador_ids = ids_a_preservar
    remover_formularios_e_respostas
    remover_turmas_e_matriculas
    CriadorFormulario.where.not(id: admin_criador_ids).delete_all
    Usuario.where.not(id: admin_usuario_ids).delete_all
    Departamento.where.not(id: admin_depto_ids).delete_all
  end

  # Coleta os IDs dos admins, seus departamentos e seus criadores de
  # formulário que devem ser preservados após a limpeza.
  #
  # Argumentos: nenhum.
  # Retorno: Array de três Arrays:
  #   [admin_usuario_ids, admin_depto_ids, admin_criador_ids].
  # Efeitos colaterais: nenhum (somente leituras no banco).
  def ids_a_preservar
    admin_usuario_ids = Admin.pluck(:usuario_id)
    admin_depto_ids   = Admin.pluck(:departamento_id)
    admin_criador_ids = CriadorFormulario.where(usuario_id: admin_usuario_ids).pluck(:id)
    [ admin_usuario_ids, admin_depto_ids, admin_criador_ids ]
  end

  # Remove todos os registros ligados a formulários: respostas, perguntas,
  # vínculos e os próprios formulários e templates.
  #
  # Argumentos: nenhum.
  # Retorno: nenhum.
  # Efeitos colaterais: apaga registros em RespostaPergunta,
  # RespostaFormulario, PerguntaFormulario, Formulario, Pergunta e
  # TemplateFormulario.
  def remover_formularios_e_respostas
    RespostaPergunta.delete_all
    RespostaFormulario.delete_all
    PerguntaFormulario.delete_all
    Formulario.delete_all
    Pergunta.delete_all
    TemplateFormulario.delete_all
  end

  # Remove todos os registros de turmas, matrículas e perfis de pessoas
  # (professores, estudantes e matérias).
  #
  # Argumentos: nenhum.
  # Retorno: nenhum.
  # Efeitos colaterais: apaga registros em Matricula, Turma, Professor,
  # Estudante e Materia.
  def remover_turmas_e_matriculas
    Matricula.delete_all
    Turma.delete_all
    Professor.delete_all
    Estudante.delete_all
    Materia.delete_all
  end
end
