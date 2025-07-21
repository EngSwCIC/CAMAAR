#language: pt
Funcionalidade: Gerar relatório do administrador
Eu como Administrador
Quero baixar um arquivo csv contendo os resultados de um formulário
A fim de avaliar o desempenho das turmas

  Contexto:
    Dado que eu estou logado como admin
    E que existem 1 formulário respondido
    E que existem 1 formulário não respondido
    E que eu estou na página de resultados do CAMAAR

  Cenário: Baixar resultados com sucesso (HAPPY)
    E eu clicar em "Download" em um formulário respondido
    Então eu devo estar na página de resultados do CAMAAR
    E um arquivo ".csv" deve ser baixado
    E eu devo ver "Arquivo de resultado baixado com sucesso"

  Cenário: Tentar baixar resultados de um formulario sem respostas (SAD)
    E eu clicar em "Download" em um formulário não respondido
    Então eu devo estar na página de resultados do CAMAAR
    E eu devo ver "Este formulário ainda não contém respostas"