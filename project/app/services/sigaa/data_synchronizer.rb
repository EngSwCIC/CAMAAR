module Sigaa
  ##
  # Coordena os importadores de turmas e participantes e consolida suas contagens.
  class DataSynchronizer
    # Resultado imutável da sincronização completa, incluindo o estado de atualização.
    Result = Data.define(:created_count, :updated_count, :inconsistencies, :already_up_to_date?)

    ##
    # Inicializa a sincronização de um semestre.
    #
    # === Argumentos
    #
    # +semester:+:: Período letivo que será sincronizado.
    # +imported_by:+:: User administrador que iniciou a operação.
    # +classes_path:ClassesImporter::DEFAULT_PATH+:: Caminho do JSON de turmas.
    # +members_path:ClassMembersImporter::DEFAULT_PATH+:: Caminho do JSON de participantes.
    #
    # === Retorno
    #
    # Retorna uma nova instância de Sigaa::DataSynchronizer.
    #
    # === Efeitos colaterais
    #
    # Armazena os argumentos em memória; não lê arquivos nem persiste registros.
    def initialize(semester:, imported_by:, classes_path: ClassesImporter::DEFAULT_PATH, members_path: ClassMembersImporter::DEFAULT_PATH)
      @semester = semester
      @imported_by = imported_by
      @classes_path = classes_path
      @members_path = members_path
    end

    ##
    # Executa sequencialmente a importação de turmas e participantes.
    #
    # Não recebe argumentos.
    #
    # Retorna Result com contagens consolidadas, inconsistências e indicação de que
    # a base já estava atualizada.
    #
    # Efeitos colaterais: lê os arquivos de origem e pode criar ou atualizar todos os
    # registros e e-mails tratados pelos dois importadores.
    def call
      classes_result = ClassesImporter.new(path: classes_path, semester:, imported_by:).call
      members_result = ClassMembersImporter.new(path: members_path, semester:, imported_by:).call

      build_result(classes_result, members_result)
    end

    ##
    # Descobre os semestres disponíveis nos dois arquivos de importação.
    #
    # === Argumentos
    #
    # +classes_path:ClassesImporter::DEFAULT_PATH+:: Caminho do arquivo JSON de turmas.
    # +members_path:ClassMembersImporter::DEFAULT_PATH+:: Caminho do arquivo JSON de participantes.
    #
    # === Retorno
    #
    # Retorna um Array sem duplicatas, ordenado do semestre mais recente para o mais antigo.
    #
    # === Efeitos colaterais
    #
    # Lê ambos os arquivos e pode lançar erros de leitura ou JSON::ParserError.
    def self.available_semesters(classes_path: ClassesImporter::DEFAULT_PATH, members_path: ClassMembersImporter::DEFAULT_PATH)
      from_classes = JSON.parse(File.read(classes_path)).filter_map { |entry| entry.dig("class", "semester") }
      from_members = JSON.parse(File.read(members_path)).filter_map { |entry| entry["semester"] }

      (from_classes + from_members).uniq.sort.reverse
    end

    private

    # Semestre, administrador e caminhos de origem usados pela sincronização.
    attr_reader :semester, :imported_by, :classes_path, :members_path

    def build_result(classes_result, members_result)
      created_count = classes_result.created_count + members_result.created_count
      updated_count = classes_result.updated_count + members_result.updated_count
      Result.new(
        created_count:,
        updated_count:,
        inconsistencies: members_result.inconsistencies,
        already_up_to_date?: created_count.zero? && updated_count.zero?
      )
    end
  end
end
