require 'watir'
require 'webdrivers'


# NOTA: Provavelmente seria uma boa ideia extender a classe browser pra ter as nossas funções como métodos de instância

def login(browser, usuario, senha)
  browser.text_field(name: 'user.login').set usuario
  browser.text_field(name: 'user.senha').set senha
  browser.button(value: 'Entrar').click
end


browser = Watir::Browser.new 
browser.goto 'https://sigaa.unb.br/sigaa/verTelaLogin.do'

login(browser, ENV["SIGAA_USER"], ENV["SIGAA_SENHA"])

browser.screenshot.save ("blau.png")

