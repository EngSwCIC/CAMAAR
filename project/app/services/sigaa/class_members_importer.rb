module Sigaa
  ##
  # Importa participantes e vínculos de turma, registrando inconsistências e
  # enviando instruções de senha para usuários recém-criados.
  class ClassMembersImporter
    # Resultado imutável com quantidades de criações, atualizações e inconsistências.
    Result = Data.define(:created_count, :updated_count, :inconsistencies)

    # Caminho padrão do arquivo JSON de participantes na raiz do repositório.
    DEFAULT_PATH = Rails.root.join("..", "class_members.json")

    ##
    # Inicializa o importador de participantes.
    #
    # === Argumentos
    #
    # +path:DEFAULT_PATH+:: Caminho do arquivo JSON; utiliza DEFAULT_PATH por padrão.
    # +semester:nil+:: Período letivo que será filtrado ou +nil+ para importar todos.
    # +imported_by:nil+:: User administrador que iniciou a importação ou +nil+.
    #
    # === Retorno
    #
    # Retorna uma nova instância de Sigaa::ClassMembersImporter.
    #
    # === Efeitos colaterais
    #
    # Armazena os argumentos em memória; não lê o arquivo nem persiste registros.
    def initialize(path: DEFAULT_PATH, semester: nil, imported_by: nil)
      @path = path
      @semester = semester
      @imported_by = imported_by
    end

    ##
    # Sincroniza usuários e vínculos encontrados no arquivo de participantes.
    #
    # Não recebe argumentos.
    #
    # Retorna Result com quantidades de criações, atualizações e inconsistências.
    #
    # Efeitos colaterais: lê o JSON, cria ou atualiza turmas, departamentos, usuários,
    # vínculos e inconsistências e pode enviar e-mails de definição de senha.
    def call
      counts = { created: 0, updated: 0, inconsistencies: 0 }

      parsed_data.each do |class_payload|
        course_class = find_or_create_course_class(class_payload)
        members_for(class_payload).each do |member_payload, membership_role|
          process_member(member_payload, membership_role, course_class, counts)
        end
      end

      Result.new(created_count: counts[:created], updated_count: counts[:updated], inconsistencies: counts[:inconsistencies])
    end

    private

    # Caminho de origem, semestre selecionado e administrador que iniciou a importação.
    attr_reader :path, :semester, :imported_by

    ##
    # Lê o arquivo de participantes e aplica o filtro opcional de semestre.
    #
    # Não recebe argumentos.
    #
    # Retorna um Array de hashes do JSON, completo ou filtrado.
    #
    # Efeitos colaterais: lê o arquivo e pode lançar erros de leitura ou JSON::ParserError.
    def parsed_data
      data = JSON.parse(File.read(path))
      return data if semester.blank?

      data.select { |entry| entry["semester"] == semester }
    end

    ##
    # Localiza ou cria a turma descrita por um bloco do arquivo de participantes.
    #
    # === Argumentos
    #
    # +class_payload+:: Hash com código, turma, semestre e nome da disciplina.
    #
    # === Retorno
    #
    # Retorna a CourseClass encontrada ou criada.
    #
    # === Efeitos colaterais
    #
    # Pode criar departamento e turma no banco ou lançar erros por dados obrigatórios ausentes.
    def find_or_create_course_class(class_payload)
      code = class_payload.fetch("code")
      department = department_for(code)

      CourseClass.find_or_create_by!(
        code:,
        class_code: class_payload.fetch("classCode"),
        semester: class_payload.fetch("semester")
      ) do |course_class|
        course_class.department = department
        course_class.name = class_payload["name"]
      end
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

    ##
    # Normaliza docentes e discentes de uma turma em pares de participante e papel.
    #
    # === Argumentos
    #
    # +class_payload+:: Hash da turma contendo coleções de docentes e discentes.
    #
    # === Retorno
    #
    # Retorna um Array de pares +[member_payload, role]+.
    #
    # === Efeitos colaterais
    #
    # Não possui efeitos colaterais.
    def members_for(class_payload)
      class_payload.flat_map do |key, value|
        next [] unless %w[dicente docente].include?(key)

        role = key == "docente" ? :docente : :discente
        members = value.is_a?(Array) ? value : (value.is_a?(Hash) ? [ value ] : [])
        members.map { |member_payload| [ member_payload, role ] }
      end
    end

    ##
    # Verifica se um participante não possui e-mail ou matrícula.
    #
    # === Argumentos
    #
    # +member_payload+:: Hash com os dados do participante.
    #
    # === Retorno
    #
    # Retorna +true+ quando falta um dado obrigatório e +false+ caso contrário.
    #
    # === Efeitos colaterais
    #
    # Não possui efeitos colaterais.
    def invalid_member?(member_payload)
      member_payload["email"].blank? || member_registration(member_payload).blank?
    end

    ##
    # Extrai a matrícula acadêmica ou o identificador alternativo do participante.
    #
    # === Argumentos
    #
    # +member_payload+:: Hash com os dados do participante.
    #
    # === Retorno
    #
    # Retorna o valor de +matricula+, o valor de +usuario+ ou +nil+.
    #
    # === Efeitos colaterais
    #
    # Não possui efeitos colaterais.
    def member_registration(member_payload)
      member_payload["matricula"].presence || member_payload["usuario"].presence
    end

    ##
    # Registra um participante inválido para análise posterior.
    #
    # === Argumentos
    #
    # +member_payload+:: Hash original que apresentou inconsistência.
    # +message+:: Descrição legível do problema encontrado.
    #
    # === Retorno
    #
    # Retorna o ImportInconsistency criado.
    #
    # === Efeitos colaterais
    #
    # Insere uma inconsistência no banco e pode lançar ActiveRecord::RecordInvalid.
    def register_inconsistency(member_payload, message)
      ImportInconsistency.create!(source: "class_members.json", message:, payload: member_payload)
    end

    ##
    # Cria ou atualiza o usuário correspondente ao participante importado.
    #
    # === Argumentos
    #
    # +member_payload+:: Hash com nome, e-mail e matrícula do participante.
    # +department+:: Department que será associado ao usuário.
    #
    # === Retorno
    #
    # Retorna +:created+, +:updated+ ou +:unchanged+ conforme a operação realizada.
    #
    # === Efeitos colaterais
    #
    # Cria ou atualiza o usuário no banco e envia e-mail de definição de senha para contas novas.
    def sync_user(member_payload, department)
      registration = member_registration(member_payload).to_s.strip
      email = normalized_email(member_payload)
      name = member_payload["nome"]
      user = User.find_by(email:) || User.find_by(registration:)

      return create_user(name, email, registration, department) if user.nil?

      apply_user_updates(user, name, email, registration, department)
    end

    def create_user(name, email, registration, department)
      user = User.create!(name:, email:, registration:, role: :participant, department:)
      send_password_setup(user) if user.pending_password_setup?
      :created
    end

    def apply_user_updates(user, name, email, registration, department)
      updates = build_user_updates(user, name, email, registration, department)
      return :unchanged unless updates.any?

      user.update!(updates)
      :updated
    end

    def build_user_updates(user, name, email, registration, department)
      {}.tap do |u|
        u[:name] = name if user.name != name
        u[:email] = email if user.email != email
        u[:registration] = registration if user.registration != registration
        u[:department] = department if user.department_id != department.id
      end
    end

    def process_member(member_payload, membership_role, course_class, counts)
      if invalid_member?(member_payload)
        register_inconsistency(member_payload, "Participante sem email ou matricula")
        counts[:inconsistencies] += 1
        return
      end

      user_status = sync_user(member_payload, course_class.department)
      counts[:created] += 1 if user_status == :created
      counts[:updated] += 1 if user_status == :updated

      membership_status = ensure_membership(user_for(member_payload), course_class, membership_role)
      counts[:created] += 1 if membership_status == :created
    end

    ##
    # Localiza o usuário já sincronizado a partir do e-mail ou da matrícula importada.
    #
    # === Argumentos
    #
    # +member_payload+:: Hash com os dados usados na busca.
    #
    # === Retorno
    #
    # Retorna o User encontrado.
    #
    # === Efeitos colaterais
    #
    # Consulta o banco e pode lançar ActiveRecord::RecordNotFound quando não há correspondência.
    def user_for(member_payload)
      registration = member_registration(member_payload).to_s.strip
      User.find_by(email: normalized_email(member_payload)) || User.find_by!(registration:)
    end

    ##
    # Normaliza o e-mail importado removendo espaços e convertendo-o para minúsculas.
    #
    # === Argumentos
    #
    # +member_payload+:: Hash contendo o campo +email+.
    #
    # === Retorno
    #
    # Retorna uma String normalizada, inclusive vazia quando o campo não existe.
    #
    # === Efeitos colaterais
    #
    # Não possui efeitos colaterais.
    def normalized_email(member_payload)
      member_payload["email"].to_s.strip.downcase
    end

    ##
    # Gera o token inicial e entrega o e-mail de definição de senha.
    #
    # === Argumentos
    #
    # +user+:: User recém-criado que receberá as instruções.
    #
    # === Retorno
    #
    # Retorna a mensagem entregue pelo Action Mailer.
    #
    # === Efeitos colaterais
    #
    # Atualiza o token do usuário no banco e envia um e-mail de forma síncrona.
    def send_password_setup(user)
      UserMailer.password_setup(user, user.generate_password_setup_token!).deliver_now
    end

    ##
    # Garante a existência do vínculo do usuário com a turma no papel informado.
    #
    # === Argumentos
    #
    # +user+:: User que participa da turma.
    # +course_class+:: CourseClass à qual o usuário será vinculado.
    # +role+:: Papel +:discente+ ou +:docente+ do vínculo.
    #
    # === Retorno
    #
    # Retorna +:created+ quando cria o vínculo e +:unchanged+ quando ele já existia.
    #
    # === Efeitos colaterais
    #
    # Pode inserir uma ClassMembership no banco e lançar erros de persistência.
    def ensure_membership(user, course_class, role)
      membership = ClassMembership.find_or_create_by!(user:, course_class:, role:)
      membership.previously_new_record? ? :created : :unchanged
    end
  end
end
