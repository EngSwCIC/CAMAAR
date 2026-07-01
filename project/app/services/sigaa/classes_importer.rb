##
# Serviços responsáveis por importar e sincronizar os dados exportados pelo SIGAA.
module Sigaa
  ##
  # Importa as turmas de um semestre, criando registros novos e atualizando nome
  # ou horário de turmas existentes.
  class ClassesImporter
    # Resultado imutável com as quantidades de turmas criadas e atualizadas.
    Result = Data.define(:created_count, :updated_count)

    # Caminho padrão do arquivo JSON de turmas na raiz do repositório.
    DEFAULT_PATH = Rails.root.join("..", "classes.json")

    ##
    # Inicializa o importador de turmas.
    #
    # === Argumentos
    #
    # +path:DEFAULT_PATH+:: Caminho do arquivo JSON; utiliza DEFAULT_PATH por padrão.
    # +semester:+:: Período letivo que será importado.
    # +imported_by:nil+:: User administrador que iniciou a importação ou +nil+.
    #
    # === Retorno
    #
    # Retorna uma nova instância de Sigaa::ClassesImporter.
    #
    # === Efeitos colaterais
    #
    # Armazena os argumentos em memória; não lê o arquivo nem persiste registros.
    def initialize(path: DEFAULT_PATH, semester:, imported_by: nil)
      @path = path
      @semester = semester
      @imported_by = imported_by
    end

    ##
    # Sincroniza as turmas do semestre configurado.
    #
    # Não recebe argumentos.
    #
    # Retorna Result com as quantidades de registros criados e atualizados.
    #
    # Efeitos colaterais: lê o JSON e cria ou atualiza departamentos, turmas e,
    # quando necessário, o departamento do administrador.
    def call
      counts = { created: 0, updated: 0 }

      entries_for_semester.each do |entry|
        attrs = extract_class_attrs(entry)
        course_class = find_course_class(attrs)
        sync_course_class(course_class, attrs, counts)
      end

      Result.new(created_count: counts[:created], updated_count: counts[:updated])
    end

    private

    # Caminho de origem, semestre selecionado e administrador que iniciou a importação.
    attr_reader :path, :semester, :imported_by

    ##
    # Seleciona do arquivo apenas as entradas do semestre configurado.
    #
    # Não recebe argumentos.
    #
    # Retorna um Array de hashes provenientes do JSON.
    #
    # Efeitos colaterais: lê o arquivo indicado por +path+ e pode lançar erros de
    # leitura ou JSON::ParserError.
    def entries_for_semester
      JSON.parse(File.read(path)).select do |entry|
        entry.dig("class", "semester") == semester
      end
    end

    ##
    # Converte uma entrada do JSON nos atributos aceitos por CourseClass.
    #
    # === Argumentos
    #
    # +entry+:: Hash de uma disciplina e sua turma no formato exportado pelo SIGAA.
    #
    # === Retorno
    #
    # Retorna um Hash com +code+, +name+, +class_code+, +semester+ e +time+.
    #
    # === Efeitos colaterais
    #
    # Não altera dados; pode lançar KeyError quando faltam chaves obrigatórias.
    def extract_class_attrs(entry)
      class_info = entry.fetch("class")
      {
        code: entry.fetch("code"),
        name: entry.fetch("name"),
        class_code: class_info.fetch("classCode"),
        semester: class_info.fetch("semester"),
        time: class_info["time"]
      }
    end

    ##
    # Obtém ou cria o departamento ao qual um código de disciplina pertence.
    #
    # === Argumentos
    #
    # +code+:: Código da disciplina usado como alternativa para inferir o departamento.
    #
    # === Retorno
    #
    # Retorna o Department encontrado ou criado.
    #
    # === Efeitos colaterais
    #
    # Pode criar um departamento e associá-lo ao administrador no banco de dados.
    def department_for(code)
      department_code = resolve_department_code(code)
      department = Department.find_or_create_by!(code: department_code) { |dept| dept.name = department_code }
      imported_by.update!(department:) if imported_by && imported_by.department_id.nil?
      department
    end

    def resolve_department_code(code)
      imported_by&.department&.code || code.to_s[/\A[A-Za-z]+/]&.upcase || "GERAL"
    end

    def find_course_class(attrs)
      CourseClass.find_by(code: attrs[:code], class_code: attrs[:class_code], semester: attrs[:semester])
    end

    def sync_course_class(course_class, attrs, counts)
      if course_class.nil?
        CourseClass.create!(attrs.merge(department: department_for(attrs[:code])))
        counts[:created] += 1
      elsif course_class_attributes_changed?(course_class, attrs)
        course_class.update!(attrs.slice(:name, :time))
        counts[:updated] += 1
      end
    end

    ##
    # Verifica se nome ou horário de uma turma existente precisam ser atualizados.
    #
    # === Argumentos
    #
    # +course_class+:: CourseClass atualmente persistida.
    # +attrs+:: Hash com os atributos importados.
    #
    # === Retorno
    #
    # Retorna +true+ quando nome ou horário diferem e +false+ quando são iguais.
    #
    # === Efeitos colaterais
    #
    # Não possui efeitos colaterais.
    def course_class_attributes_changed?(course_class, attrs)
      course_class.name != attrs[:name] || course_class.time != attrs[:time]
    end
  end
end
