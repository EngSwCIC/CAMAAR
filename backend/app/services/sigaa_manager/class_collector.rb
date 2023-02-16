require 'watir'
require 'webdrivers'
require './sigaa_login.rb'


module SigaaManager#:nodoc: don't document this

  # A classe ClassCollector é responsável pelo acesso ao sigaa e pela extração de uma ou mais turmas presentes no SIGAA, trazendo informações sobre código, nome, turma, semestre e horário das turmas.
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

    # Método utilzado para executar o serviço de extrair turmas e suas respectivas informações presentes do SIGAA.
    #
    # ==== Attributes
    #
    # * +params+ - +Hash+ de parametros do tipo +ActionController::Parameters+
    #
    # ===== +params+
    #
    # O atributo +params+ é vazio.

    def call(params)
        browser = login_sigga
        turmasSigaaInfo = get_classes_info browser
    end


    # Retorna um +Array+ de objetos do tipo +Hash+ contendo informações sobre as turmas de acordo com o login que o +browser+ se encontra.
    #
    # ==== Attributes
    #
    # * +browser+ - objeto do tipo +Watir::Browser+ representando um web-browser que acabou de realizar o login no SIGAA.
    # ==== Exemplo 
    #
    #    puts ClassCollector.new.get_classes_info(browser)
    #    #      [
    #    #        {"code"=>"CIC0161","name"=>"AUTÔMATOS E COMPUTABILIDADE","class"=>{"classCode"=>"T01","semester"=>"2022.2","time"=>"245T45"}},
    #    #        {"code"=>"CIC0105","name"=>"ENGENHARIA DE SOFTWARE","class"=>{"classCode"=>"T02","semester"=>"2022.2","time"=>"35M12"}},
    #    #        {"code"=>"CIC0142","name"=>"INFORMATICA E SOCIEDADE","class"=>{"classCode"=>"T02","semester"=>"2022.2","time"=>"6M34"}},
    #    #        {"code"=>"CIC0133","name"=>"PROGRAMACAO FUNCIONAL","class"=>{"classCode"=>"T01","semester"=>"2022.2","time"=>"24M34"}}
    #    #      ]

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

    # Retorna objeto do tipo +Hash+ contendo informações sobre uma única turma de acordo com o login que o +browser+ se encontra.
    #
    # ==== Attributes
    #
    # * +browser+ - objeto do tipo +Watir::Browser+ representando um web-browser está logado no SIGAA dentro da página de uma turma.
    # ==== Exemplo 
    #
    #    puts ClassCollector.new.get_class_info(browser)
    #    #{"class"=>{"classCode"=>"T02", "semester"=>"2022.2", "time"=>"35M12"}, "code"=>"CIC0105", "name"=>"ENGENHARIA DE SOFTWARE"}

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
