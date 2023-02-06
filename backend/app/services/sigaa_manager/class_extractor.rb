module SigaaManager
  class ClassExtractor < ApplicationService
    def call(params)
      browser = self.class.loginSigaa
      extractClasses(browser, params)

    end

    def extractClasses(browser, params)

      classes = []
      materiaElements = browser.elements(tag_name: "td", class: "descricao")
      materiaElements.each do |materiaElement|

        materiaElement.form.a.click
        turma = {}

        turma["codigo"] = browser.element(id: 'linkCodigoTurma').text.delete(" -")
        turma["nome"] = browser.element(id: 'linkNomeTurma').text
        turma["turma"],turma["semestre"], turma["horario"] = browser.element(id: 'linkPeriodoTurma').text.delete("-()").split(' ')
        puts(turma)
        if params["classes"].detect{|t| t['codigo']==turma['codigo'] and
                                    t['turma'] == turma['turma'] and
                                    t['semestre'] == turma['semestre']}
          classes.append(extractClass(turma, browser))
        end

        browser.back

      end
      return classes.to_json
    end
 
    def extractClass(turma, browser)
      class_hash = {:code => turma["codigo"],
                    :classCode => turma["turma"],
                   }
      
      browser.link(:text =>"Participantes").click
      participantes = browser.elements(class: "participantes", tag_name: "table")

      docenteElement = participantes.first

      discentesElement = participantes.last
      discentesInfos = discentesElement.elements(tag_name: "td")

      class_hash[:docente] = parseDocente docenteElement.text

      
      class_hash[:dicente] = discentesInfos.select{|info| not info.text.empty?}.map{|info| parseDiscente info.text}
      puts("#{class_hash[:dicente].length} alunos")
      browser.back

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
