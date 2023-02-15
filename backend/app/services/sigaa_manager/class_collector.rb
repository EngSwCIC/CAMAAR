require 'watir'
require 'webdrivers'
require './sigaa_login.rb'

module SigaaManager
  class ClassCollector < ApplicationService
    @@usuario = ENV['SIGAA_USER']
    @@senha = ENV['SIGAA_SENHA']

    def initialize()
      @browser = Watir::Browser.new :chrome, headless: true
      @browser.goto 'https://sigaa.unb.br/sigaa/verTelaLogin.do'
      @browser.text_field(name: 'user.login').set @@usuario
      @browser.text_field(name: 'user.senha').set @@senha
      @browser.button(value: 'Entrar').click
    end

    attr_accessor :browser

    def call(params)
        turmasSigaaInfo = get_classes_info
    end


    def get_classes_info
      classes_info = Array.new
      turma_elements = @browser.elements(tag_name: "td", class: "descricao")
      turma_elements.each do |turma_element|
        # vai para página da turma
        turma_element.form.a.click

        class_info = get_class_info
        classes_info.push(class_info)
        @browser.back

      end
      classes_info
    end

    def get_class_info

        class_info = {}
        more_info = {}

        class_info["code"] = @browser.element(id: 'linkCodigoTurma').text.delete(" -")
        class_info["name"] = @browser.element(id: 'linkNomeTurma').text
        more_info["classCode"],more_info["semester"], more_info["time"] = @browser.element(id: 'linkPeriodoTurma').text.delete("-()").split(' ')
        class_info["class"] = more_info

        class_info

    end
  end
end
