module SigaaManager #:nodoc: don't document this

  # A classe ClassExtractor é responsável por extrair as informações de uma ou mais turmas presentes no SIGAA, sendo essas informações código da disciplina, código da turma e participantes
  class ClassExtractor < ClassCollector
    # Método utilzado para executar o serviço de extrair informações das turmas presentes no SIGAA
    #
    # ==== Attributes
    #
    # * +params+ - +Hash+ de parametros do tipo +ActionController::Parameters+ contendo informações sobre as turmas selecionadas
    #
    # ===== +params+
    #
    # O atributo +params+ deve seguir o seguinte formato:
    #
    #    params = {"classes"=>[
    #                {"id"=>1,
    #                 "nome"=>"AUTÔMATOS E COMPUTABILIDADE",
    #                 "codigo"=>"CIC0161",
    #                 "turma"=>"T01",
    #                 "semestre"=>"2022.2",
    #                 "horario"=>"245T45"},
    #                {"id"=>2,
    #                 "nome"=>"ENGENHARIA DE SOFTWARE",
    #                 "codigo"=>"CIC0105",
    #                 "turma"=>"T02",
    #                 "semestre"=>"2022.2",
    #                 "horario"=>"35M12"}],}
    

    def call(params)
      browser = login_sigga
      extract_classes(params["classes"], browser)
    end

    # Retorna um +Array+ de objetos do tipo +Hash+ contendo informações sobre as turmas fornecidas no argumento +selected_classes+
    #
    # ==== Attributes
    #
    # * +selected_classes+ - +Array+ de objetos do tipo +Hash+ contendo informações sobre as turmas que devem ter suas informações extraídas 
    # * +browser+ - objeto do tipo +Watir::Browser+ representando um web-browser que está acessando a página principal  uma turma no SIGAA
    #
    # ===== +selected_classes+
    #
    # O atributo +selected_classes+ deve estar em um formato semelhante ao exemplo:
    #
    #    selected_classes = [
    #                {"id"=>1,
    #                 "nome"=>"AUTÔMATOS E COMPUTABILIDADE",
    #                 "codigo"=>"CIC0161",
    #                 "turma"=>"T01",
    #                 "semestre"=>"2022.2",
    #                 "horario"=>"245T45"},
    #                {"id"=>2,
    #                 "nome"=>"ENGENHARIA DE SOFTWARE",
    #                 "codigo"=>"CIC0105",
    #                 "turma"=>"T02",
    #                 "semestre"=>"2022.2",
    #                 "horario"=>"35M12"}]

    def extract_classes(selected_classes, browser)

      classes = []
      class_elements = browser.elements(tag_name: "td", class: "descricao")
      class_elements.each do |class_element|
        # vai para página 
        class_element.form.a.click

        class_info = get_class_info browser
        code = class_info["code"]
        class_code = class_info["class"]["classCode"]
        semester = class_info["class"]["semester"]
        
        # Caso a turma inspecionada seja uma das turmas de interesse definidas em params
        if selected_classes.detect{|t|
             "#{t['codigo']}_#{t['turma']}_#{t['semestre']}" == "#{code}_#{class_code}_#{semester}"}

          # Acessa a página de participantes
          browser.link(:text =>"Participantes").click 

          # Extrai informações da pagina de turma
          classes.append(extract_class(class_info, browser))

          # Volta para a página inicial da turma
          browser.back

        end

        browser.back

      end
      return classes.to_json
    end

    # Retorna +Hash+ contendo informações sobre as turmas fornecidas no argumento +selected_classes+
    #
    # ==== Attributes
    #
    # * +class_info+ -  Objeto do tipo +Hash+ contendo informações sobre a turmas que deve ter suas informações extraídas 
    # * +browser+ - objeto do tipo +Watir::Browser+ representando um web-browser que está acessando a página de participantes de uma turma no SIGAA
    #
    # ===== +class_info+
    #
    # O atributo +selected_classes+ deve estar em um formato semelhante ao exemplo:
    #
    #    class_info = {"id"=>1,
    #                  "nome"=>"AUTÔMATOS E COMPUTABILIDADE",
    #                  "codigo"=>"CIC0161",
    #                  "turma"=>"T01",
    #                  "semestre"=>"2022.2",
    #                  "horario"=>"245T45"}
    #
    # ==== Exemplo 
    #
    #    class_info = {"id"=>2,
    #                  "nome"=>"ENGENHARIA DE SOFTWARE",
    #                  "codigo"=>"CIC0105",
    #                  "turma"=>"T02",
    #                  "semestre"=>"2022.2",
    #                  "horario"=>"35M12"}
    #    puts ClassExtractor.new.extract_class(class_info, browser)
    #    # {code: "CIC0105",
    #    #  classCode: "T02",
    #    #   dicente: 
    #    #     [{
    #    #        nome: "Ana Clara Jordao Perna",
    #    #        curso: "CIÊNCIA DA COMPUTAÇÃO/CIC",
    #    #        matricula: "190084006",
    #    #        usuario: "190084006",
    #    #        formacao: "graduando",
    #    #        ocupacao: "dicente",
    #    #        email: "acjpjvjp@gmail.com"
    #    #      },
    #    #      {
    #    #        nome: "Ana Paula Oliveira da Nobrega Costa",
    #    #        curso: "ENGENHARIA DE COMPUTAÇÃO/CIC",
    #    #        matricula: "190142120",
    #    #        usuario: "190142120",
    #    #        formacao: "graduando",
    #    #        ocupacao: "dicente",
    #    #        email: "anapaulaoncosta@gmail.com"
    #    #      }],
    #      
    #    #   docente: {
    #    #     nome: "GENAINA NUNES RODRIGUES",
    #    #     departamento: "DEPTO CIÊNCIAS DA COMPUTAÇÃO",
    #    #     formacao: "DOUTORADO",
    #    #     usuario: "78334926120",
    #    #     email: "genaina@unb.br",
    #    #     ocupacao: "docente"
    #    #   }
    #    # }


    def extract_class(class_info, browser)
      class_hash = {:code => class_info["code"],
                    :classCode => class_info["class"]["classCode"],
                   }
      
      participantes = browser.elements(class: "participantes", tag_name: "table")

      docenteElement = participantes.first

      discentesElement = participantes.last
      discentesInfos = discentesElement.elements(tag_name: "td")

      class_hash[:docente] = parse_docente docenteElement.text

      
      class_hash[:dicente] = discentesInfos.select{|info| not info.text.empty?}.map{|info| parse_discente info.text}

      return class_hash

    end

    # Retorna +Hash+ contendo informações sobre um docente a partir de seu texto de descrição no SIGAA 
    #
    # ==== Attributes
    #
    # * +text+ -  +String+ representando o texto que descreve um docente na página de participantes do SIGAA
    #
    # ==== Exemplo
    #
    #    text = "VANDER RAMOS ALVES\n"\
    #           "Departamento: DEPTO CIÊNCIAS DA COMPUTAÇÃO\n"\
    #           "Formação: DOUTORADO\n"\
    #           "Usuário: 19720169893\n"\
    #           "E-Mail: valves@unb.br"
    #
    #    puts ClassExtractor.new.parse_docente(text)
    #    # {:nome=>"VANDER RAMOS ALVES",
    #    #  :departamento=>"DEPTO CIÊNCIAS DA COMPUTAÇÃO",
    #    #  :formacao=>"DOUTORADO",
    #    #  :usuario=>"19720169893",
    #    #  :email=>"valves@unb.br",
    #    #  :ocupacao=>"docente",
    #    # }




    def parse_docente(text)
      docente = {}

      nome, *lines = text.split(/\n/)

      docente[:nome] = nome
      docente[:ocupacao] = 'docente'

      lines.each do |line|
        key, value = line.split(':', 2)
        docente[key.gsub(/-/, '').parameterize.to_sym] = value.strip
      end

      return docente

    end
    # Retorna +Hash+ contendo informações sobre um discente a partir de seu texto de descrição no SIGAA 
    #
    # ==== Attributes
    #
    # * +text+ -  +String+ representando o texto que descreve um discente na página de participantes do SIGAA
    #
    #
    # ==== Exemplo
    #
    #    text = "Victor Henrique do Rego Vieira de Sousa\n"\
    #           "Curso: COMPUTAÇÃO/CIC\n"\
    #           "Matrícula: 170157491\n"\
    #           "Usuário: 170157491\n"\
    #           "E-mail: victorhrvs@gmail.com"
    #    
    #    puts ClassExtractor.new.parse_discente(text)
    #    # {:nome=>"Victor Henrique do Rego Vieira de Sousa",
    #    #  :curso=>"COMPUTAÇÃO/CIC",
    #    #  :matricula=>"170157491",
    #    #  :usuario=>"170157491",
    #    #  :formacao=>"graduando",
    #    #  :ocupacao=>"dicente",
    #    #  :email=>"victorhrvs@gmail.com"}

    def parse_discente(text)
      discente = {}
      nome, *lines = text.split(/\n/)
      discente[:nome] = nome
      discente[:ocupacao] = 'dicente'
      discente[:formacao] = 'graduando'

      lines.each do |line|
        key, value = line.split(':', 2)
        discente[key.gsub(/-/, '').parameterize.to_sym] = value.strip
      end

      discente

    end
  end

end
