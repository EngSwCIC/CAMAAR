require 'watir'
require 'webdrivers'
##
# Esta classe cuida da efetuação das requisições para o scrapper no endpoint turmas
#
# É retornado as turmas resultantes da busca das turmas no SIGAA
class Api::SearchClasses  < ApplicationController

    def self.call
        new.call
    end

    def call
        browser = openBrowser
        usuario = ENV['SIGAA_USER']
        senha = ENV['SIGAA_SENHA']
        loginSigaa(browser, usuario, senha)
        turmasSigaaInfo = getClassesInfo(browser)
    end

    def openBrowser
      browser = Watir::Browser.new :chrome, headless: true
    end

    def loginSigaa(browser, usuario, senha)
      browser.goto 'https://sigaa.unb.br/sigaa/verTelaLogin.do'
      browser.text_field(name: 'user.login').set usuario
      browser.text_field(name: 'user.senha').set senha
      browser.button(value: 'Entrar').click
      browser
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