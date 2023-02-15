module SigaaManager #:nodoc: don't document this

  # A classe ClassExtractor é responsável por extrair as informações de uma ou mais turmas presentes no SIGAA, sendo essas informações código da disciplina, código da turma e participantes
  class ClassExtractor < ClassCollector
    # Método utilzado para executar o serviço de extrair informações das turmas presentes no SIGAA
    #
    # ==== Attributes
    #
    # * +params+ - +Hash+ de parametros do tipo +ActionController::Parameters+ contendo informações sobre as turmas selecionadas
    #
    # ==== Params
    #
    # O atributo +params+ deve conter as seguintes informações
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
      extract_classes(params["classes"], @browser)
    end

    # Retorna +Hash+ contendo informações sobre as turmas fornecidas no argumento +selected_classes+
    #
    # ==== Attributes
    #
    # * +selected_classes+ - +Array+ de objetos do tipo +Hash+ contendo informações sobre as turmas que devem ter suas informações extraídas 
    #
    # ==== +selected_classes+
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
          classes.append(extract_class(class_info))

          # Volta para a página inicial da turma
          browser.back

        end

        browser.back

      end
      return classes.to_json
    end
 
    def extract_class(class_info, browser)
      class_hash = {:code => class_info["code"],
                    :classCode => class_info["class"]["classCode"],
                   }
      
      participantes = browser.elements(class: "participantes", tag_name: "table")

      docenteElement = participantes.first

      discentesElement = participantes.last
      discentesInfos = discentesElement.elements(tag_name: "td")

      class_hash[:docente] = parseDocente docenteElement.text

      
      class_hash[:dicente] = discentesInfos.select{|info| not info.text.empty?}.map{|info| parseDiscente info.text}

      return class_hash

    end


    def parseDocente(text)
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

    def parseDiscente(text)
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
