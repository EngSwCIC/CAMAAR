require 'watir'
require 'webdrivers'
require './sigaa_login.rb'

# Módulo responsável por realizar operações referentes ao SIGAA
module SigaaManager
  class ClassCollector < ApplicationService

    # Retorna uma instância da classe +Watir::Browser+ em que o browser já se encontra na página inicial do aluno do SIGAA
    def login_sigga()
      browser = Watir::Browser.new :chrome, headless: true
      browser.goto 'https://sigaa.unb.br/sigaa/verTelaLogin.do'
      browser.text_field(name: 'user.login').set ENV['SIGAA_USER']
      browser.text_field(name: 'user.senha').set ENV['SIGAA_SENHA']
      browser.button(value: 'Entrar').click
      browser
    end


    def call(params)
        browser = login_sigga
        turmasSigaaInfo = get_classes_info browser
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
