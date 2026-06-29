module Importer
  class AcademicDataImporter
    def self.import!(upload_file)
      start_time = Time.current

      file_path = File.read(upload_file.tempfile.path)
      data_hash = JSON.parse(file_path)



      ActiveRecord::Base.transaction do
        unique_turmas = data_hash.uniq { |t| [ t["code"], t["classCode"], t["semester"] ] }

        turma_objects = unique_turmas.map do |t|
          Turma.new(codigo: t["code"], turma: t["classCode"], semestre: t["semester"], departamento: "Ciência da Computação")
        end
        # duplicação de objetos
        Turma.import turma_objects, on_duplicate_key_ignore: true, validate: false

        turmas_hash = Turma.all.pluck(:codigo, :turma, :semestre, :id).each_with_object({}) do |(codigo, turma, semestre, id), hash|
          hash["#{codigo}-#{turma}-#{semestre}"] = id
        end

        # armazenar os discentes e docentes
        raw_discentes = []
        raw_docentes = []

        data_hash.each do |turma_dados|
          turma_id = turmas_hash["#{turma_dados['code']}-#{turma_dados['classCode']}-#{turma_dados['semester']}"]
          next unless turma_id

          if turma_dados["dicente"].is_a?(Array)
            turma_dados["dicente"].each do |d|
              raw_discentes << d.merge("turma_id" => turma_id)
            end
          end

          if turma_dados["docente"].is_a?(Hash)
            d_user = turma_dados["docente"]
            raw_docentes << d_user.merge("turma_id" => turma_id)
          end
        end
      

        unique_discentes = raw_discentes.uniq { |d| d["matricula"] }
        unique_docentes = raw_docentes.uniq { |d| d["email"] }

        discente_objects = unique_discentes.map do |members|
          Discente.new(
            nome: members["nome"]&.downcase,
            curso: members["curso"]&.downcase,
            matricula: members["matricula"],
            usuario: members["usuario"],
            formacao: members["formacao"]&.downcase,
            ocupacao: members["ocupacao"]&.downcase,
            email: members["email"]&.downcase,
            turma_id: members["turma_id"]
          )
        end
        Discente.import discente_objects, on_duplicate_key_ignore: true, validate: false

        users_discente_objects = unique_discentes.map do |members|
          User.new(
            nome: members["nome"]&.downcase,
            matricula: members["matricula"],
            email: members["email"],
            perfil: "Discente",
            password: "123456",
            password_confirmation: "123456",
            primeiro_acesso: false
          )
          
        end
        User.import users_discente_objects, on_duplicate_key_ignore: true, validate: false

        emails_importados = users_discente_objects.map(&:email)
        usuarios_salvos = User.where(email: emails_importados)

        usuarios_salvos.each do |usuario|
          UsuarioMailer.email_primeiro_acesso(usuario).deliver_later
        end

        docente_objects = unique_docentes.map do |members|
          Docente.new(
            nome: members["nome"]&.downcase,
            departamento: members["departamento"]&.downcase,
            usuario: members["usuario"],
            formacao: members["formacao"]&.downcase,
            ocupacao: members["ocupacao"]&.downcase,
            email: members["email"]&.downcase,
            turma: members["turma_id"]
          )
        end
        Docente.import docente_objects, on_duplicate_key_ignore: true, validate: false

        users_docente_objects = unique_docentes.map do |members|
          User.new(
            nome: members["nome"]&.downcase,
            matricula: members["email"],
            email: members["email"],
            perfil: "Docente",
            password: "123456",
            password_confirmation: "123456",
            primeiro_acesso: false
          )
        end
        
        User.import users_docente_objects, on_duplicate_key_ignore: true, validate: false
      end
      # registro de erros
    rescue StandardError => e
      error = "Erro na transação de importação: #{e.message}"
      Rails.logger.error error
      raise

    elapsed_time = Time.current - start_time
      Rails.logger.info "Tempo total de importação: #{elapsed_time.round(2)} segundos"
      true
    end
  end
end