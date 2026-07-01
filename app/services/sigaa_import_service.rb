class SigaaImportService
  def self.processar(caminho_classes, caminho_membros)
    classes_json = JSON.parse(File.read(caminho_classes))
    membros_json = JSON.parse(File.read(caminho_membros))

    ActiveRecord::Base.transaction do
      turmas_temp = processar_disciplinas(classes_json)
      membros_json.each { |m| processar_membro(m, turmas_temp) }
    end
  end

  def self.processar_disciplinas(classes_json)
    turmas_temp = {}
    classes_json.each do |c|
      Disciplina.find_or_create_by!(codigo: c['code']) do |d|
        d.nome = c['name']
      end
      chave = "#{c['code']}_#{c['class']['classCode']}_#{c['class']['semester']}"
      turmas_temp[chave] = c['class']['time']
    end
    turmas_temp
  end
  private_class_method :processar_disciplinas

  def self.processar_membro(m, turmas_temp)
    docente = processar_docente(m['docente'])
    turma = processar_turma(m, docente, turmas_temp)
    m['dicente'].each { |disc_data| processar_discente(disc_data, turma) }
  end
  private_class_method :processar_membro

  def self.processar_turma(m, docente, turmas_temp)
    chave_turma = "#{m['code']}_#{m['classCode']}_#{m['semester']}"
    horario = turmas_temp[chave_turma]

    Turma.find_or_create_by!(
      disciplina_id: m['code'],
      codigo: m['classCode'],
      semestre: m['semester'],
      docente_id: docente.id
    ) do |t|
      t.horario = horario
    end
  end
  private_class_method :processar_turma

  def self.atualizar_dados_pessoa(pessoa, dados)
    pessoa.nome = dados['nome']
    pessoa.email = dados['email']
    pessoa.formacao = dados['formacao']
    pessoa.ocupacao = dados['ocupacao']
    if pessoa.new_record? || pessoa.password_digest.blank?
      pessoa.password_digest = SecureRandom.hex(10)
      pessoa.reset_password_token = SecureRandom.urlsafe_base64
    end
    pessoa.save!
    pessoa
  end
  private_class_method :atualizar_dados_pessoa

  def self.processar_docente(doc_data)
    pessoa_doc = atualizar_dados_pessoa(Pessoa.find_or_initialize_by(usuario: doc_data['usuario']), doc_data)

    Docente.find_or_create_by!(pessoa_id: pessoa_doc.usuario) do |d|
      d.departamento = doc_data['departamento']
    end
  end
  private_class_method :processar_docente

  def self.processar_discente(disc_data, turma)
    pessoa_disc = atualizar_dados_pessoa(Pessoa.find_or_initialize_by(usuario: disc_data['usuario']), disc_data)

    discente = Discente.find_or_create_by!(pessoa_id: pessoa_disc.usuario) do |d|
      d.curso = disc_data['curso']
      d.matricula = disc_data['matricula']
    end

    TurmaDiscente.find_or_create_by!(turma_id: turma.id, discente_id: discente.id)
  end
  private_class_method :processar_discente
end