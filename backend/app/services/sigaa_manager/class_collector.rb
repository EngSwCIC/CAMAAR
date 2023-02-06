
module SigaaManager
  class ClassCollector < ApplicationService

    def call(params)
        sigaa_browser = self.class.loginSigaa
        turmasSigaaInfo = getClassesInfo(sigaa_browser)
    end


    def getClassesInfo(browser)
      todasTurmas = Array.new
      materiasTableTds = browser.elements(tag_name: "td", class: "descricao")
      materiasTableTds.each do |materia|
        clicarTurma = materia.form.a.click
        turma = browser.element(tag_name: "#nomeTurma")
        turmaCod = browser.element(id: 'linkCodigoTurma').text.delete(" -")
        turmaNome = browser.element(id: 'linkNomeTurma').text
        turmaInfos = browser.element(id: 'linkPeriodoTurma').text.delete("-()").split(' ')
        turmaHash = Hash.new
        turmaHash = {"code": turmaCod, "name": turmaNome, "class": { "classCode":turmaInfos[0], "semester":turmaInfos[1], "time":turmaInfos[2] } }
        todasTurmas.push(turmaHash)
        browser.back
      end
      todasTurmas
    end
  end
end
