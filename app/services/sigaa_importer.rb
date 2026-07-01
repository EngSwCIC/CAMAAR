require 'json'

# Serviço para importar dados do SIGAA.
class SigaaImporter
  class << self
    # Importa turmas do JSON para o banco de dados.
    #
    # Argumentos: json_content (String)
    # Retorno: Hash com status e mensagem
    # Efeitos Colaterais: Cria disciplinas e turmas no banco.
    def import_classes(json_content)
      begin
        data = parse_json_data(json_content)
        process_classes_data(data)
        { success: true, message: "Dados de turmas importados com sucesso: #{data.size} novas turmas processadas" }
      rescue JSON::ParserError
        { success: false, message: "Erro na estrutura do arquivo: campos obrigatórios ausentes ou JSON inválido" }
      rescue => e
        { success: false, message: "Erro na estrutura do arquivo: #{e.message}" }
      end
    end

    # Importa participantes (docentes e discentes) do JSON.
    #
    # Argumentos: json_content (String)
    # Retorno: Hash com status e mensagem
    # Efeitos Colaterais: Cria usuários, docentes e discentes no banco.
    def import_members(json_content)
      begin
        data = parse_json_data(json_content)
        process_members_data(data)
        { success: true, message: "Participantes importados com sucesso" }
      rescue JSON::ParserError
        { success: false, message: "Erro na estrutura do arquivo: campos obrigatórios ausentes ou JSON inválido" }
      rescue => e
        { success: false, message: "Erro na estrutura do arquivo: #{e.message}" }
      end
    end

    private

    # Transforma string em array de hash.
    #
    # Argumentos: json_content (String)
    # Retorno: Array de Hashes
    # Efeitos Colaterais: Nenhum
    def parse_json_data(json_content)
      data = JSON.parse(json_content)
      data.is_a?(Array) ? data : [data]
    end

    # Itera sobre os dados para importar as classes.
    #
    # Argumentos: data (Array)
    # Retorno: Nenhum
    # Efeitos Colaterais: Chama persistencia no BD.
    def process_classes_data(data)
      data.each do |item|
        next unless item.is_a?(Hash)
        validate_class_structure!(item)
        import_single_class(item)
      end
    end

    # Valida estrutura da classe.
    #
    # Argumentos: item (Hash)
    # Retorno: Nenhum
    # Efeitos Colaterais: Lança exceção se faltarem campos.
    def validate_class_structure!(item)
      raise "campos obrigatórios ausentes" unless item['code'] && item['class'] && item['class']['classCode']
    end

    # Importa uma disciplina e turma individualmente.
    #
    # Argumentos: item (Hash)
    # Retorno: Nenhum
    # Efeitos Colaterais: Cria no BD.
    def import_single_class(item)
      disciplina = Disciplina.find_or_create_by!(code: item['code']) do |d|
        d.name = item['name']
      end

      Turma.find_or_create_by!(
        classCode: item['class']['classCode'],
        semester: item['class']['semester'],
        disciplina: disciplina
      ) do |t|
        t.time = item['class']['time']
      end
    end

    # Processa dados dos membros.
    #
    # Argumentos: data (Array)
    # Retorno: Nenhum
    # Efeitos Colaterais: Busca e persiste.
    def process_members_data(data)
      data.each do |item|
        next unless item.is_a?(Hash)
        turma = find_turma(item)
        next unless turma
        
        import_discentes(item['dicente'] || [], turma)
        import_docente(item['docente'], turma) if item['docente']
      end
    end

    # Localiza turma pelo hash.
    #
    # Argumentos: item (Hash)
    # Retorno: Turma ou nil
    # Efeitos Colaterais: Busca no BD.
    def find_turma(item)
      disciplina = Disciplina.find_by(code: item['code'])
      return nil unless disciplina
      Turma.find_by(classCode: item['classCode'], semester: item['semester'], disciplina: disciplina)
    end

    # Importa discentes.
    #
    # Argumentos: dicentes (Array), turma (Turma)
    # Retorno: Nenhum
    # Efeitos Colaterais: Persiste discentes.
    def import_discentes(dicentes, turma)
      dicentes.each do |d_data|
        create_discente_record(d_data, turma)
        create_or_invite_user(d_data['matricula'], d_data['email'], 'discente')
      end
    end

    # Cria ou busca o discente
    #
    # Argumentos: d_data (Hash), turma (Turma)
    # Retorno: Nenhum
    # Efeitos Colaterais: Cria discente no banco
    def create_discente_record(d_data, turma)
      Discente.find_or_create_by!(matricula: d_data['matricula'], turma: turma) do |d|
        d.nome = d_data['nome']
        d.curso = d_data['curso']
        d.usuario = d_data['usuario']
        d.formacao = d_data['formacao']
        d.ocupacao = d_data['ocupacao']
        d.email = d_data['email']
      end
    end

    # Importa docente.
    #
    # Argumentos: doc_data (Hash), turma (Turma)
    # Retorno: Nenhum
    # Efeitos Colaterais: Persiste docentes.
    def import_docente(doc_data, turma)
      Docente.find_or_create_by!(usuario: doc_data['usuario'], turma: turma) do |doc|
        doc.nome = doc_data['nome']
        doc.departamento = doc_data['departamento']
        doc.formacao = doc_data['formacao']
        doc.email = doc_data['email']
        doc.ocupacao = doc_data['ocupacao']
      end

      create_or_invite_user(doc_data['usuario'], doc_data['email'], 'docente')
    end

    # Cria usuário e gera convite caso não exista.
    #
    # Argumentos: matricula, email, role
    # Retorno: Nenhum
    # Efeitos Colaterais: Cria usuário
    def create_or_invite_user(matricula, email, role)
      User.find_or_create_by!(matricula: matricula) do |u|
        u.email = email
        u.role = role
        u.generate_invitation_token!
      end
    end
  end
end
