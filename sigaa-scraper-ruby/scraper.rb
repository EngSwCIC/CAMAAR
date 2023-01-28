require 'watir'
require 'webdrivers'


# NOTA: Provavelmente seria uma boa ideia extender a classe browser pra ter as nossas funções como métodos de instância

def login(browser, usuario, senha)
  browser.text_field(name: 'user.login').set usuario
  browser.text_field(name: 'user.senha').set senha
  browser.button(value: 'Entrar').click
end

# TODO: Função para retornar as turmas cadastradas no SIGAA (LUCAS E EDUARDO)
def get_classes(browser)
  #A função deve ser chamada com o browser já logado no sigaa para funcionar.
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
  #todasTurmas é o que será retornado dessa função
  #A linha abaixo serve apenas para teste.
  puts todasTurmas
end

# TODO: Função para retornar os membros de cada turma cadastradas no SIGAA (TIAGO E GABRIEL)
def get_members(class_id)
end


browser = Watir::Browser.new 
browser.goto 'https://sigaa.unb.br/sigaa/verTelaLogin.do'

login(browser, ENV["SIGAA_USER"], ENV["SIGAA_SENHA"])


