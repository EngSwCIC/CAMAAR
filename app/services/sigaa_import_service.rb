class SigaaImportService
  def self.processar(caminho_classes, caminho_membros)
    classes_json = JSON.parse(File.read(caminho_classes))
    membros_json = JSON.parse(File.read(caminho_membros))

    ActiveRecord::Base.transaction do
      turmas_temp = {}

      classes_json.each do |c|
        Disciplina.find_or_create_by!(codigo: c['code']) do |d|
          d.nome = c['name']
        end
        chave = "#{c['code']}_#{c['class']['classCode']}_#{c['class']['semester']}"
        turmas_temp[chave] = c['class']['time']
      end

      membros_json.each do |m|
        doc_data = m['docente']
        pessoa_doc = Pessoa.find_or_initialize_by(usuario: doc_data['usuario'])
        pessoa_doc.nome = doc_data['nome']
        pessoa_doc.email = doc_data['email']
        pessoa_doc.formacao = doc_data['formacao']
        pessoa_doc.ocupacao = doc_data['ocupacao']
        if pessoa_doc.new_record? || pessoa_doc.password_digest.blank?
          pessoa_doc.password_digest = SecureRandom.hex(10)
          pessoa_doc.reset_password_token = SecureRandom.urlsafe_base64
        end
        pessoa_doc.save!

        docente = Docente.find_or_create_by!(pessoa_id: pessoa_doc.usuario) do |d|
          d.departamento = doc_data['departamento']
        end

        chave_turma = "#{m['code']}_#{m['classCode']}_#{m['semester']}"
        horario = turmas_temp[chave_turma]

        turma = Turma.find_or_create_by!(
          disciplina_id: m['code'],
          codigo: m['classCode'],
          semestre: m['semester'],
          docente_id: docente.id
        ) do |t|
          t.horario = horario
        end

        m['dicente'].each do |disc_data|
          pessoa_disc = Pessoa.find_or_initialize_by(usuario: disc_data['usuario'])
          pessoa_disc.nome = disc_data['nome']
          pessoa_disc.email = disc_data['email']
          pessoa_disc.formacao = disc_data['formacao']
          pessoa_disc.ocupacao = disc_data['ocupacao']
          if pessoa_disc.new_record? || pessoa_disc.password_digest.blank?
            pessoa_disc.password_digest = SecureRandom.hex(10)
            pessoa_disc.reset_password_token = SecureRandom.urlsafe_base64
          end
          pessoa_disc.save!
          discente = Discente.find_or_create_by!(pessoa_id: pessoa_disc.usuario) do |d|
            d.curso = disc_data['curso']
            d.matricula = disc_data['matricula']
          end

          TurmaDiscente.find_or_create_by!(turma_id: turma.id, discente_id: discente.id)
        end
      end
    end
  end
end