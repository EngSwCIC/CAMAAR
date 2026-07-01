# frozen_string_literal: true

require "json"

module SIGAA
  class ImportData
    Result = Struct.new(:status, :errors, keyword_init: true) do
      def missing_file?
        status == :missing_file
      end

      def success?
        status == :success
      end

      def partial?
        status == :partial
      end

      def message
        return "Arquivo JSON não encontrado em db/" if missing_file?
        return "Dados do SIGAA importados e sincronizados com sucesso!" if success?

        "A importação foi concluída parcialmente."
      end
    end

    def self.call(path: Rails.root.join("db", "usuarios_sigaa.json"))
      new(path: path).call
    end

    def initialize(path:)
      @path = path
      @context = {
        codigos_materias_ativos: [],
        turmas_ativas_ids: [],
        matriculas_ativas_json: [],
        erros_importacao: []
      }
    end

    def call
      return result(:missing_file) unless File.exist?(path)

      data = JSON.parse(File.read(path))
      import_data(data)
      sync_removals
      result(import_errors.empty? ? :success : :partial)
    end

    private

    attr_reader :path, :context

    def import_data(data)
      import_materias(data)
      import_turmas(data)
      import_docentes(data)
      import_discentes(data)
    end

    def import_materias(data)
      data["materias"]&.each { |materia_data| import_materia(materia_data) }
    end

    def import_materia(materia_data)
      code = materia_data["codigo"]

      ActiveRecord::Base.transaction do
        context[:codigos_materias_ativos] << code
        materia = Materia.find_or_initialize_by(codigo: code)
        materia.nome = materia_data["nome"]
        materia.departamento_id = materia_data["departamento_id"]
        materia.save!
      end
    rescue StandardError => error
      import_errors << "Matéria #{materia_data['nome']} (Código: #{code}): #{error.message}"
    end

    def import_turmas(data)
      data["turmas"]&.each { |turma_data| import_turma(turma_data) }
    end

    def import_turma(turma_data)
      ActiveRecord::Base.transaction do
        materia = find_materia!(turma_data["materia_codigo"])
        turma = save_turma!(turma_data, materia)
        context[:turmas_ativas_ids] << turma.id
      end
    rescue StandardError => error
      import_errors << "Turma nº #{turma_data['numero']} (#{turma_data['ano']}/#{turma_data['semestre']}) da matéria '#{turma_data['materia_codigo']}': #{error.message}"
    end

    def save_turma!(turma_data, materia)
      turma = Turma.find_or_initialize_by(
        numero: turma_data["numero"],
        ano: turma_data["ano"],
        semestre: turma_data["semestre"],
        materia_id: materia.id
      )
      turma.save!
      turma
    end

    def import_docentes(data)
      data["usuarios_docentes"]&.each { |docente_data| import_docente(docente_data) }
    end

    def import_docente(docente_data)
      matricula = docente_data["matricula"]

      ActiveRecord::Base.transaction do
        sync_docente!(docente_data, matricula)
      end
    rescue StandardError => error
      import_errors << "Docente #{docente_data['nome']} (Matrícula: #{matricula}): #{error.message}"
    end

    def sync_docente!(docente_data, matricula)
      context[:matriculas_ativas_json] << matricula
      usuario = save_imported_user!(docente_data, matricula)
      save_perfil_docente!(usuario, docente_data)
      sync_docente_participacoes!(usuario, docente_data)
    end

    def save_perfil_docente!(usuario, docente_data)
      perfil = PerfilDocente.find_or_initialize_by(id: usuario.id)
      perfil.departamento_id = docente_data["departamento_id"]
      perfil.save!
    end

    def import_participacoes_docente!(usuario, docente_data)
      turma_ids = []
      (docente_data["turmas_lecionadas"] || []).each do |materia_data|
        import_participacao!(usuario, materia_data, :docente, turma_ids)
      end
      turma_ids
    end

    def sync_docente_participacoes!(usuario, docente_data)
      turma_ids = import_participacoes_docente!(usuario, docente_data)
      usuario.participacoes_turma.docentes.where.not(turma_id: turma_ids).destroy_all
    end

    def import_discentes(data)
      data["usuarios_discentes"]&.each { |discente_data| import_discente(discente_data) }
    end

    def import_discente(discente_data)
      matricula = discente_data["matricula"]

      ActiveRecord::Base.transaction do
        sync_discente!(discente_data, matricula)
      end
    rescue StandardError => error
      import_errors << "Discente #{discente_data['nome']} (Matrícula: #{matricula}): #{error.message}"
    end

    def sync_discente!(discente_data, matricula)
      context[:matriculas_ativas_json] << matricula
      usuario = save_imported_user!(discente_data, matricula)
      PerfilDiscente.find_or_create_by!(id: usuario.id)
      sync_discente_participacoes!(usuario, discente_data)
    end

    def import_participacoes_discente!(usuario, discente_data)
      turma_ids = []
      discente_data["turmas_matriculadas"].each do |materia_data|
        import_participacao!(usuario, materia_data, :discente, turma_ids)
      end
      turma_ids
    end

    def sync_discente_participacoes!(usuario, discente_data)
      turma_ids = import_participacoes_discente!(usuario, discente_data)
      usuario.participacoes_turma.where.not(turma_id: turma_ids).destroy_all
    end

    def save_imported_user!(user_data, matricula)
      usuario = Usuario.find_or_initialize_by(matricula: matricula)
      usuario.nome = user_data["nome"]
      usuario.email = user_data["email"]
      initialize_imported_user(usuario)
      usuario.save!
      usuario
    end

    def initialize_imported_user(usuario)
      return unless usuario.new_record?

      usuario.status = 0
      usuario.senha = ""
    end

    def import_participacao!(usuario, materia_data, tipo_participacao, turma_ids)
      turma = find_turma!(materia_data)
      turma_ids << turma.id
      ParticipacaoTurma.find_or_create_by!(
        usuario_id: usuario.id,
        turma_id: turma.id,
        tipo_participacao: tipo_participacao
      )
    end

    def find_materia!(code)
      materia = Materia.find_by(codigo: code)
      raise "Matéria com código '#{code}' não existe no sistema." if materia.nil?

      materia
    end

    def find_turma!(materia_data)
      materia = find_materia!(materia_data["materia_codigo"])
      turma = Turma.find_by(
        materia_id: materia.id,
        numero: materia_data["numero_turma"],
        ano: materia_data["ano"],
        semestre: materia_data["semestre"]
      )
      return turma if turma.present?

      raise "Turma nº #{materia_data['numero_turma']} (#{materia_data['ano']}/#{materia_data['semestre']}) da matéria '#{materia.nome}' não foi localizada no sistema."
    end

    def sync_removals
      ActiveRecord::Base.transaction do
        Turma.where.not(id: context[:turmas_ativas_ids]).destroy_all
        Materia.where.not(codigo: context[:codigos_materias_ativos]).destroy_all
        remove_non_admin_users(context[:matriculas_ativas_json])
      end
    end

    def remove_non_admin_users(active_matriculas)
      Usuario
        .where.missing(:perfil_adm)
        .where.not(matricula: active_matriculas)
        .find_each(&:destroy!)
    end

    def result(status)
      Result.new(status: status, errors: import_errors)
    end

    def import_errors
      context[:erros_importacao]
    end
  end
end
