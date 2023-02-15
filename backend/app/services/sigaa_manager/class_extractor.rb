module SigaaManager
  # A classe ClassExtractor é responsável por extrair as informações de uma ou mais turmas presentes no SIGAA
  class ClassExtractor < ClassCollector
    def call(params)
      browser = self.class.loginSigaa
      extract_classes(browser, params)

    end

    def extract_classes(browser, params)

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
        if params["classes"].detect{|t|
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
 
    def extract_class(class_info, browserMembersPage)
      class_hash = {:code => class_info["code"],
                    :classCode => class_info["class"]["classCode"],
                   }
      
      participantes = browserMembersPage.elements(class: "participantes", tag_name: "table")

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
