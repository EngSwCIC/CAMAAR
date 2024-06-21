require 'json'
require 'logger'

# Inicializa o logger
logger = Logger.new(STDOUT)

begin
  # Lê o arquivo JSON e converte em um hash
  file = File.read('class_members.json')
  data_hash = JSON.parse(file)
  print(data_hash)
rescue => e
  logger.error("Erro ao ler ou parsear o arquivo JSON: #{e.message}")
  exit
end

data_hash.each do |class_info|
  # Itera sobre cada aluno no array 'dicente'
  class_info["dicente"].each do |aluno|
    begin
      existing_aluno = Aluno.find_by(email: aluno["email"])
      if existing_aluno
        logger.info("Aluno já existe: #{aluno["email"]}")
        next
      end

      # Gera uma senha aleatória
      password = Array.new(8) { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join

      # Cria o aluno
      Aluno.create!(
        nome: aluno["nome"],
        curso: aluno["curso"],
        matricula: aluno["matricula"],
        email: aluno["email"],
        password: password,
        password_confirmation: password
      )
      logger.info("Aluno criado: #{aluno["email"]}")

    rescue => e
      logger.error("Erro ao criar aluno #{aluno["email"]}: #{e.message}")
    end
  end

  # Itera sobre cada professor no array 'docente'
  class_info["docente"].each do |professor|
    begin
      existing_professor = Professor.find_by(email: professor["email"])
      if existing_professor
        logger.info("Professor já existe: #{professor["email"]}")
        next
      end

      # Gera uma senha aleatória
      password = Array.new(8) { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join

      # Recupera ou cria o departamento associado
      departamento_nome = professor["departamento"]
      if departamento_nome.nil? || departamento_nome.strip.empty?
        logger.error("Professor #{professor["email"]} não tem departamento especificado.")
        next
      end

      departamento = Departamento.find_or_create_by(nome: departamento_nome)

      # Determina se o professor é um administrador
      is_admin = professor["ocupacao"]&.downcase == "coordenador"

      # Cria o professor com a instância de Departamento
      Professor.create!(
        nome: professor["nome"],
        email: professor["email"],
        password: password,
        password_confirmation: password,
        departamento: departamento,  # Passa a instância do departamento
        isadmin: is_admin
      )
      logger.info("Professor criado: #{professor["email"]} com isadmin: #{is_admin}")

    rescue => e
      logger.error("Erro ao criar professor #{professor["email"]}: #{e.message}")
    end
  end
end
