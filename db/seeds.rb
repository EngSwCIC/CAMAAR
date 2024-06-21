require 'json'
require 'logger'


logger = Logger.new(STDOUT)

begin
  
  file = File.read('class_members.json')
  data_hash = JSON.parse(file)
  print(data_hash)
rescue => e
  logger.error("Erro ao ler ou parsear o arquivo JSON: #{e.message}")
  exit
end

data_hash.each do |class_info|
 
  class_info["discente"].each do |aluno|
    begin
      existing_aluno = Aluno.find_by(email: aluno["email"])
      if existing_aluno
        logger.info("Aluno já existe: #{aluno["email"]}")
        next
      end

     
      password = Array.new(8) { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join

 
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


  class_info["docente"].each do |professor|
    begin
      existing_professor = Professor.find_by(email: professor["email"])
      if existing_professor
        logger.info("Professor já existe: #{professor["email"]}")
        next
      end

      
      password = Array.new(8) { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join

      
      departamento_nome = professor["departamento"]
      if departamento_nome.nil? || departamento_nome.strip.empty?
        logger.error("Professor #{professor["email"]} não tem departamento especificado.")
        next
      end

      departamento = Departamento.find_or_create_by(nome: departamento_nome)

      
      is_admin = professor["ocupacao"]&.downcase == "coordenador"

      
      Professor.create!(
        nome: professor["nome"],
        email: professor["email"],
        password: password,
        password_confirmation: password,
        departamento: departamento, 
        isadmin: is_admin
      )
      logger.info("Professor criado: #{professor["email"]} com isadmin: #{is_admin}")

    rescue => e
      logger.error("Erro ao criar professor #{professor["email"]}: #{e.message}")
    end
  end
end
