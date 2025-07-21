class ImportadorSigaa
  def initialize(json_data)
    @json_data = json_data
    @atualizado = false
  end

  def processar
    @json_data.each do |turma_info|
      importar_materia(turma_info)
      importar_professor(turma_info)
      turma = importar_turma(turma_info)
      importar_alunos(turma_info, turma)
    end
    @atualizado
  end

  private

  def importar_materia(info)
    materia = Materia.find_by(id: info["code"])
    if materia
      if materia.nome != info["name"]
        materia.update!(nome: info["name"])
        @atualizado = true
      end
    else
      Materia.create!(id: info["code"], nome: info["name"])
    end
  end

  def importar_professor(info)
    docente = info["docente"]
    pessoa = Pessoa.find_by(email: docente["email"])

    if pessoa
      updated = false
      updated |= pessoa.update!(nome: docente["nome"]) if pessoa.nome != docente["nome"]
      updated |= pessoa.update!(matricula: docente["matricula"]) if pessoa.matricula != docente["matricula"]
      @atualizado ||= updated
    else
      pessoa = Pessoa.create!(
        nome: docente["nome"],
        matricula: docente["matricula"],
        email: docente["email"],
        senha: "testeProfessor"
      )
    end

    Cargo.find_or_create_by!(email: pessoa.email) do |c|
      c.funcao = 1
    end
  end

  def importar_turma(info)
    turma = Turma.find_by(id: info["id"])
    if turma
      atualizado = false
      atualizado |= turma.id_materia != info["code"]
      atualizado |= turma.numero_turma != info["classCode"].to_i
      atualizado |= turma.semestre != info["semester"]
      atualizado |= turma.professor != info["docente"]["email"]

      turma.id_materia = info["code"]
      turma.numero_turma = info["classCode"].to_i
      turma.semestre = info["semester"]
      turma.professor = info["docente"]["email"]
      turma.save!

      @atualizado ||= atualizado
      turma
    else
      Turma.create!(
        id: info["id"],
        id_materia: info["code"],
        numero_turma: info["classCode"].to_i,
        semestre: info["semester"],
        professor: info["docente"]["email"]
      )
    end
  end

  def importar_alunos(info, turma)
    info["dicente"].each do |aluno|
      pessoa = Pessoa.find_by(email: aluno["usuario"])
      novo_usuario = false

      if pessoa
        if pessoa.nome != aluno["nome"]
          pessoa.update!(nome: aluno["nome"])
          @atualizado = true
        end
      else
        pessoa = Pessoa.create!(
          nome: aluno["nome"],
          matricula: aluno["matricula"],
          email: aluno["usuario"],
          senha: nil
        )
        novo_usuario = true
      end

      Cargo.find_or_create_by!(email: pessoa.email) do |c|
        c.funcao = 2 # 2 = aluno
      end

      Participante.find_or_create_by!(
        email: pessoa.email,
        id_turma: turma.id
      )

      if novo_usuario
        raw_token, enc_token = Devise.token_generator.generate(Pessoa, :reset_password_token)
        pessoa.update!(
          reset_password_token: enc_token,
          reset_password_sent_at: Time.current
        )
        Devise::Mailer.reset_password_instructions(pessoa, raw_token).deliver_now

        url = Rails.application.routes.url_helpers.edit_pessoa_password_url(reset_password_token: raw_token, host: "localhost:3000")

        Rails.logger.info("[Cadastro de usuarios] Email enviado para #{pessoa.email} com token #{raw_token}")
        File.open(Rails.root.join("log", "emails_enviados.log"), "a") do |f|
          f.puts "[#{Time.current}] Enviado para #{pessoa.email} - Token: #{raw_token} - URL: #{url}"
        end
      end
    end
  end
end
