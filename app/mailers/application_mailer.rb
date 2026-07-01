## Classe base para os mailers do rails
##
# === Descrição
# Classe que define o remetente <tt>ES2026_Grupo01@camaar.com</tt> e layout padrão de e-mails
# === Argumentos
# * Nenhum.
# === Retorno
# * +nil+
# === Efeitos Colaterais
# * Nenhum.
class ApplicationMailer < ActionMailer::Base
  default from: "ES2026_Grupo01@camaar.com"
  layout "mailer"
end
