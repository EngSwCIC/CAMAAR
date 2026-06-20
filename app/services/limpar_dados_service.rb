class LimparDadosService
  def call
    conn = ActiveRecord::Base.connection

    # Necessário desabilitar a verficiação de FK do SQLite. Desabilitar checagem para evitar erro de constraints enquanto a migração ocorre
    conn.execute("PRAGMA foreign_keys = OFF")

    ActiveRecord::Base.transaction do
      admin_usuario_ids = Admin.pluck(:usuario_id)
      admin_depto_ids   = Admin.pluck(:departamento_id)
      admin_criador_ids = CriadorFormulario.where(usuario_id: admin_usuario_ids).pluck(:id)

      RespostaPergunta.delete_all
      RespostaFormulario.delete_all
      PerguntaFormulario.delete_all
      Formulario.delete_all
      Pergunta.delete_all
      TemplateFormulario.delete_all
      CriadorFormulario.where.not(id: admin_criador_ids).delete_all
      Matricula.delete_all
      Turma.delete_all
      Professor.delete_all
      Estudante.delete_all
      Materia.delete_all
      Usuario.where.not(id: admin_usuario_ids).delete_all
      Departamento.where.not(id: admin_depto_ids).delete_all
    end

    { success: true }
  rescue StandardError => e
    { success: false, error: e.message }
  ensure
    conn.execute("PRAGMA foreign_keys = ON")
  end
end
