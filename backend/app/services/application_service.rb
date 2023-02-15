require 'watir'
require 'webdrivers'
require './sigaa_login.rb'

class ApplicationService

  @@usuario = ENV['SIGAA_USER']
  @@senha = ENV['SIGAA_SENHA']

  def self.call(params = {})
    new().call(params)
  end

  def self.loginSigaa
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'https://sigaa.unb.br/sigaa/verTelaLogin.do'
    browser.text_field(name: 'user.login').set @@usuario
    browser.text_field(name: 'user.senha').set @@senha
    browser.button(value: 'Entrar').click
    browser
    end

end
