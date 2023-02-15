
module SigaaManager
  class ClassCollector < ApplicationService

    def call(params)
        sigaa_browser = self.class.loginSigaa
        turmasSigaaInfo = get_classes_info(sigaa_browser)
    end


    def get_classes_info(browser)
      classes_info = Array.new
      turma_elements = browser.elements(tag_name: "td", class: "descricao")
      turma_elements.each do |turma_element|
        # vai para página da turma
        turma_element.form.a.click

        class_info = get_class_info browser
        classes_info.push(class_info)
        browser.back

      end
      classes_info
    end

    def get_class_info(browser)

        class_info = {}
        more_info = {}

        class_info["code"] = browser.element(id: 'linkCodigoTurma').text.delete(" -")
        class_info["name"] = browser.element(id: 'linkNomeTurma').text
        more_info["classCode"],more_info["semester"], more_info["time"] = browser.element(id: 'linkPeriodoTurma').text.delete("-()").split(' ')
        class_info["class"] = more_info

        class_info

    end
  end
end
